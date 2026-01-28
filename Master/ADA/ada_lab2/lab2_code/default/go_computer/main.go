package main

import (
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strconv"
	"strings"
	"sync/atomic"
	"syscall"
	"time"

	"github.com/streadway/amqp"
)

type Payload struct {
	String       string `json:"string"`
	Difficulty   int    `json:"difficulty"`
	ConsumerID   string `json:"consumer_id"`
	ThreadOffset int    `json:"thread_offset"`
	TotalThreads int    `json:"total_threads"`
	PuzzleID     string `json:"puzzle_id"`
}

type StopMessage struct {
	PuzzleID string `json:"puzzle_id"`
}

var (
	shouldStop    int32
	currentPuzzle string
	consumerID    string
)

// generateSimpleUUID creates a simple UUID-like string without external dependencies
func generateSimpleUUID() string {
	b := make([]byte, 16)
	_, err := rand.Read(b)
	if err != nil {
		// Fallback to timestamp-based ID
		return fmt.Sprintf("consumer-%d", time.Now().UnixNano())
	}
	return fmt.Sprintf("%x-%x-%x-%x-%x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func solveCryptoPuzzle(str string, difficulty int, threadOffset int, totalThreads int, puzzleID string) string {
	log.Printf("Solving crypto puzzle with string=%q difficulty=%d offset=%d total=%d", 
		str, difficulty, threadOffset, totalThreads)
	
	needle := strings.Repeat("0", difficulty)
	
	// Start from the thread offset and increment by total threads
	for n := uint64(threadOffset); atomic.LoadInt32(&shouldStop) == 0; n += uint64(totalThreads) {
		// Check if we should stop (another consumer found solution)
		if atomic.LoadInt32(&shouldStop) == 1 || currentPuzzle != puzzleID {
			log.Printf("Stopping search - solution found by another consumer or new puzzle started")
			return ""
		}
		
		solutionCandidate := str + strconv.FormatUint(n, 10)
		hash := sha256.Sum256([]byte(solutionCandidate))
		result := hex.EncodeToString(hash[:])
		
		if result[:difficulty] == needle {
			log.Printf("Solution found: %s (hash: %s) by consumer %s", solutionCandidate, result, consumerID)
			return solutionCandidate
		}
		
		if n%1000000 == 0 && threadOffset == 0 { // Only log from first thread to avoid spam
			log.Printf("Still searching... tried %d candidates", n)
		}
	}
	
	return ""
}

func sendHeartbeat(channel *amqp.Channel) {
	ticker := time.NewTicker(10 * time.Second)
	defer ticker.Stop()
	
	for {
		select {
		case <-ticker.C:
			heartbeat := map[string]interface{}{
				"consumer_id": consumerID,
				"timestamp":   time.Now().Unix(),
			}
			
			data, err := json.Marshal(heartbeat)
			if err != nil {
				log.Printf("Error marshaling heartbeat: %v", err)
				continue
			}
			
			err = channel.Publish(
				"",
				"consumer-heartbeat",
				false,
				false,
				amqp.Publishing{
					Body: data,
				},
			)
			if err != nil {
				log.Printf("Error sending heartbeat: %v", err)
			}
		}
	}
}

func main() {
	consumerID = generateSimpleUUID()
	log.Printf("Consumer ID: %s", consumerID)
	
	user := "guest"
	password := "guest"
	host := "rabbitmq:5672"
	queueName := "crypto-puzzle-inquiries"
	stopQueueName := "crypto-puzzle-stop"

	connStr := fmt.Sprintf("amqp://%s:%s@%s/", user, password, host)
	log.Printf("Connecting to RabbitMQ at %s", host)
	conn, err := amqp.Dial(connStr)
	if err != nil {
		log.Fatalf("Failed to connect to RabbitMQ: %v", err)
	}
	defer func() {
		log.Println("Closing RabbitMQ connection")
		conn.Close()
	}()

	channel, err := conn.Channel()
	if err != nil {
		log.Fatalf("Failed to open channel: %v", err)
	}
	defer func() {
		log.Println("Closing RabbitMQ channel")
		channel.Close()
	}()

	// Declare main queue
	queue, err := channel.QueueDeclare(
		queueName,
		false, // durable
		true,  // auto-delete
		false, // exclusive
		false, // no-wait
		nil,   // args
	)
	if err != nil {
		log.Fatalf("Failed to declare queue: %v", err)
	}

	// Declare stop queue
	stopQueue, err := channel.QueueDeclare(
		stopQueueName,
		false, // durable
		true,  // auto-delete
		false, // exclusive
		false, // no-wait
		nil,   // args
	)
	if err != nil {
		log.Fatalf("Failed to declare stop queue: %v", err)
	}

	// Declare heartbeat queue
	_, err = channel.QueueDeclare(
		"consumer-heartbeat",
		false, // durable
		true,  // auto-delete
		false, // exclusive
		false, // no-wait
		nil,   // args
	)
	if err != nil {
		log.Fatalf("Failed to declare heartbeat queue: %v", err)
	}

	log.Printf("Declared queues")

	// Start heartbeat
	go sendHeartbeat(channel)

	// Consume work messages
	msgs, err := channel.Consume(
		queue.Name,
		consumerID, // consumer tag
		true,       // auto-ack
		false,      // exclusive
		false,      // no-local
		false,      // no-wait
		nil,        // args
	)
	if err != nil {
		log.Fatalf("Failed to register consumer: %v", err)
	}

	// Consume stop messages
	stopMsgs, err := channel.Consume(
		stopQueue.Name,
		consumerID+"-stop", // consumer tag
		true,               // auto-ack
		false,              // exclusive
		false,              // no-local
		false,              // no-wait
		nil,                // args
	)
	if err != nil {
		log.Fatalf("Failed to register stop consumer: %v", err)
	}

	log.Println("Consumer registered, waiting for messages...")

	sigs := make(chan os.Signal, 1)
	signal.Notify(sigs, syscall.SIGINT, syscall.SIGTERM)

	// Handle stop messages
	go func() {
		for d := range stopMsgs {
			var stopMsg StopMessage
			if err := json.Unmarshal(d.Body, &stopMsg); err != nil {
				log.Printf("Error decoding stop message: %v", err)
				continue
			}
			
			if stopMsg.PuzzleID == currentPuzzle {
				log.Printf("Received stop signal for puzzle %s", stopMsg.PuzzleID)
				atomic.StoreInt32(&shouldStop, 1)
			}
		}
	}()

	// Handle work messages
	go func() {
		for d := range msgs {
			log.Printf("Received work message: CorrelationId=%s ReplyTo=%s", d.CorrelationId, d.ReplyTo)

			var jsonPayload Payload
			if err := json.Unmarshal(d.Body, &jsonPayload); err != nil {
				log.Printf("Error decoding JSON: %v", err)
				continue
			}

			// Check if this message is for this consumer
			if jsonPayload.ConsumerID != consumerID {
				log.Printf("Message not for this consumer (expected %s, got %s)", consumerID, jsonPayload.ConsumerID)
				continue
			}

			log.Printf("Payload: %+v", jsonPayload)
			
			// Reset stop flag and set current puzzle
			atomic.StoreInt32(&shouldStop, 0)
			currentPuzzle = jsonPayload.PuzzleID
			
			solution := solveCryptoPuzzle(
				jsonPayload.String,
				jsonPayload.Difficulty,
				jsonPayload.ThreadOffset,
				jsonPayload.TotalThreads,
				jsonPayload.PuzzleID,
			)

			// Only send response if we found a solution
			if solution != "" {
				err = channel.Publish(
					"", // default exchange
					d.ReplyTo,
					false,
					false,
					amqp.Publishing{
						CorrelationId: d.CorrelationId,
						Body:          []byte(solution),
					},
				)
				if err != nil {
					log.Printf("Error publishing response: %v", err)
				} else {
					log.Printf("Published solution for CorrelationId=%s", d.CorrelationId)
				}
			}
		}
	}()

	<-sigs
	log.Println("Shutting down...")
}