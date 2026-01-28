import time
import pika
import hashlib
import json
import logging
import threading
import uuid
from threading import Event
import signal
import sys

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S'
)

# Reduce Pika's verbose logging
logging.getLogger('pika').setLevel(logging.WARNING)

# Global variables for coordination
stop_event = Event()
current_puzzle_id = None
consumer_id = str(uuid.uuid4())
shutdown_event = Event()

logging.info(f"Starting consumer with ID: {consumer_id}")

user = 'guest'
password = 'guest'
host = 'rabbitmq'
port = 5672
queue_name = 'crypto-puzzle-inquiries'
stop_queue_name = 'crypto-puzzle-stop'
heartbeat_queue_name = 'consumer-heartbeat'


def solve_crypto_puzzle(string, difficulty, thread_offset, total_threads, puzzle_id):
    global stop_event, current_puzzle_id
    
    sha256 = hashlib.sha256
    needle = '0' * difficulty
    n = thread_offset
    
    logging.info(f"Solving crypto puzzle for string '{string}' with difficulty {difficulty}, "
                f"offset {thread_offset}, total threads {total_threads}")
    
    while not stop_event.is_set() and current_puzzle_id == puzzle_id:
        solution_candidate = string + str(n)
        result = sha256(solution_candidate.encode()).hexdigest()
        
        if result[:difficulty] == needle:
            logging.info(f"Solution found: {solution_candidate}")
            return solution_candidate
        
        n += total_threads
        
        # Log progress occasionally (only from thread 0 to avoid spam)
        if thread_offset == 0 and n % 1000000 == 0:
            logging.info(f"Still searching... tried {n} candidates")
    
    logging.info("Search stopped - solution found by another consumer or stop signal received")
    return None


def send_heartbeat():
    """Send periodic heartbeat to server"""
    while not shutdown_event.is_set():
        try:
            credentials = pika.PlainCredentials(user, password)
            parameters = pika.ConnectionParameters(host=host, port=port, credentials=credentials)
            connection = pika.BlockingConnection(parameters)
            channel = connection.channel()
            
            # Declare heartbeat queue
            channel.queue_declare(queue=heartbeat_queue_name, auto_delete=True)
            
            heartbeat_data = {
                'consumer_id': consumer_id,
                'timestamp': int(time.time())
            }
            
            channel.basic_publish(
                exchange='',
                routing_key=heartbeat_queue_name,
                body=json.dumps(heartbeat_data)
            )
            
            connection.close()
            time.sleep(10)  # Send heartbeat every 10 seconds
            
        except Exception as e:
            logging.error(f"Error sending heartbeat: {e}")
            time.sleep(5)  # Wait before retrying


def handle_stop_messages():
    """Handle stop messages from server in separate connection"""
    global stop_event, current_puzzle_id
    
    while not shutdown_event.is_set():
        try:
            credentials = pika.PlainCredentials(user, password)
            parameters = pika.ConnectionParameters(host=host, port=port, credentials=credentials)
            connection = pika.BlockingConnection(parameters)
            channel = connection.channel()
            
            # Declare stop queue
            channel.queue_declare(queue=stop_queue_name, auto_delete=True)
            
            def stop_callback(ch, method, properties, body):
                global stop_event, current_puzzle_id
                try:
                    stop_data = json.loads(body)
                    puzzle_id = stop_data.get('puzzle_id')
                    
                    if puzzle_id == current_puzzle_id:
                        logging.info(f"Received stop signal for puzzle {puzzle_id}")
                        stop_event.set()
                        
                except Exception as e:
                    logging.error(f"Error processing stop message: {e}")
            
            channel.basic_consume(
                queue=stop_queue_name,
                on_message_callback=stop_callback,
                auto_ack=True
            )
            
            # Use a timeout to periodically check for shutdown
            connection.process_data_events(time_limit=1)
            
        except Exception as e:
            if not shutdown_event.is_set():
                logging.error(f"Error in stop message handler: {e}")
                time.sleep(5)
            break


def signal_handler(signum, frame):
    """Handle shutdown signals"""
    logging.info("Received shutdown signal")
    shutdown_event.set()
    stop_event.set()


def main():
    global stop_event, current_puzzle_id
    
    # Set up signal handlers
    signal.signal(signal.SIGINT, signal_handler)
    signal.signal(signal.SIGTERM, signal_handler)
    
    # Start heartbeat thread
    heartbeat_thread = threading.Thread(target=send_heartbeat, daemon=True)
    heartbeat_thread.start()
    
    # Start stop message handler thread
    stop_thread = threading.Thread(target=handle_stop_messages, daemon=True)
    stop_thread.start()
    
    logging.info("Consumer threads started, waiting for work messages...")
    
    try:
        while not shutdown_event.is_set():
            try:
                credentials = pika.PlainCredentials(user, password)
                parameters = pika.ConnectionParameters(host=host, port=port, credentials=credentials)
                connection = pika.BlockingConnection(parameters)
                channel = connection.channel()
                
                # Declare work queue
                channel.queue_declare(queue=queue_name, auto_delete=True)
                
                def work_callback(ch, method, properties, body):
                    global stop_event, current_puzzle_id
                    
                    logging.info("Received a work message")
                    try:
                        json_payload = json.loads(body)
                        
                        # Check if this message is for this consumer
                        if json_payload.get('consumer_id') != consumer_id:
                            logging.info(f"Message not for this consumer")
                            return
                        
                        string = json_payload['string']
                        difficulty = json_payload['difficulty']
                        thread_offset = json_payload['thread_offset']
                        total_threads = json_payload['total_threads']
                        puzzle_id = json_payload['puzzle_id']
                        
                        # Reset stop event and set current puzzle
                        stop_event.clear()
                        current_puzzle_id = puzzle_id
                        
                        logging.info(f"Processing work: offset={thread_offset}, total={total_threads}")
                        
                        solution = solve_crypto_puzzle(string, difficulty, thread_offset, total_threads, puzzle_id)
                        
                        # Only send response if we found a solution and still working on same puzzle
                        if solution and current_puzzle_id == puzzle_id:
                            ch.basic_publish(
                                exchange='',
                                routing_key=properties.reply_to,
                                properties=pika.BasicProperties(correlation_id=properties.correlation_id),
                                body=solution
                            )
                            logging.info("Solution sent back successfully")
                        
                    except Exception as e:
                        logging.error(f"Error processing work message: {e}")
                
                channel.basic_consume(
                    queue=queue_name,
                    on_message_callback=work_callback,
                    auto_ack=True
                )
                
                # Process events with timeout to allow graceful shutdown
                while not shutdown_event.is_set():
                    connection.process_data_events(time_limit=1)
                
                connection.close()
                break
                
            except Exception as e:
                if not shutdown_event.is_set():
                    logging.error(f"Connection error: {e}")
                    time.sleep(5)  # Wait before retrying
                else:
                    break
    
    except KeyboardInterrupt:
        logging.info("Interrupted by user")
    
    logging.info("Shutting down consumer...")
    shutdown_event.set()
    stop_event.set()


if __name__ == "__main__":
    main()