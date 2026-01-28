#!/usr/bin/ruby
# frozen_string_literal: true

require 'bunny'
require 'securerandom'
require 'json'
require 'time'

user = 'guest'
password = 'guest'
host = 'rabbitmq:5672'
queue_name = 'crypto-puzzle-inquiries'
reply_queue_name = 'crypto-puzzle-responses'
heartbeat_queue_name = 'consumer-heartbeat'
stop_queue_name = 'crypto-puzzle-stop'

connection = Bunny.new "amqp://#{user}:#{password}@#{host}"
connection.start

lock = Mutex.new
condition = ConditionVariable.new
active_consumers = {} # Hash with consumer_id => last_heartbeat_time
current_puzzle_id = nil
puzzle_solved = false
HEARTBEAT_TIMEOUT = 30 # seconds

channel = connection.create_channel
exchange = channel.default_exchange

# Declare queues
queue = channel.queue(queue_name, auto_delete: true)
reply_queue = channel.queue(reply_queue_name, auto_delete: true, exclusive: true)
heartbeat_queue = channel.queue(heartbeat_queue_name, auto_delete: true)
stop_queue = channel.queue(stop_queue_name, auto_delete: true)

# Handle heartbeat messages from consumers
heartbeat_queue.subscribe do |_delivery_info, _properties, payload|
  consumer_data = JSON.parse(payload)
  consumer_id = consumer_data['consumer_id']
  
  lock.synchronize do
    was_new = !active_consumers.key?(consumer_id)
    active_consumers[consumer_id] = Time.now
    
    if was_new
      puts "New consumer #{consumer_id} registered. Total consumers: #{active_consumers.size}"
    end
  end
end

# Handle solution responses
reply_queue.subscribe do |_delivery_info, properties, payload|
  lock.synchronize do
    if properties.correlation_id == current_puzzle_id && !puzzle_solved
      puts "Solution found: #{payload}"
      puzzle_solved = true
      
      # Notify all consumers to stop
      stop_message = { puzzle_id: current_puzzle_id }.to_json
      active_consumers.keys.each do |consumer_id|
        exchange.publish(stop_message, routing_key: stop_queue_name)
      end
      
      condition.signal
    end
  end
end

# Cleanup inactive consumers periodically
cleanup_thread = Thread.new do
  loop do
    sleep(15) # Check every 15 seconds
    lock.synchronize do
      current_time = Time.now
      inactive_consumers = []
      
      active_consumers.each do |consumer_id, last_heartbeat|
        if current_time - last_heartbeat > HEARTBEAT_TIMEOUT
          inactive_consumers << consumer_id
        end
      end
      
      inactive_consumers.each do |consumer_id|
        active_consumers.delete(consumer_id)
        puts "Consumer #{consumer_id} removed (timeout). Total consumers: #{active_consumers.size}"
      end
    end
  end
end

begin
  loop do
    puts 'Press Ctrl+C to exit'
    puts 'Enter difficulty of puzzle from 1 to 8:'

    difficulty = $stdin.gets.to_i
    if (1..8).include?(difficulty)
      lock.synchronize do
        # Wait a moment for consumers to register
        puts "Waiting for consumers to register..."
        sleep(2)
        
        if active_consumers.empty?
          puts "No active consumers found. Please start some consumers first."
          next
        end
        
        current_puzzle_id = SecureRandom.uuid
        puzzle_solved = false
        
        consumer_count = active_consumers.size
        puts "Distributing work among #{consumer_count} consumers"
        
        # Send work to each consumer with their specific offset
        active_consumers.keys.each_with_index do |consumer_id, index|
          payload = {
            string: 'Hello World',
            difficulty: difficulty,
            consumer_id: consumer_id,
            thread_offset: index,
            total_threads: consumer_count,
            puzzle_id: current_puzzle_id
          }
          
          exchange.publish(
            payload.to_json,
            routing_key: queue.name,
            correlation_id: current_puzzle_id,
            reply_to: reply_queue.name
          )
        end
        
        puts 'Computation in progress...'
        condition.wait(lock, 60) # Wait up to 60 seconds for solution
        
        if !puzzle_solved
          puts "Timeout reached. No solution found within 60 seconds."
          # Send stop signal anyway
          stop_message = { puzzle_id: current_puzzle_id }.to_json
          active_consumers.keys.each do |consumer_id|
            exchange.publish(stop_message, routing_key: stop_queue_name)
          end
        end
      end
    else
      puts "Incorrect value. You've introduced #{difficulty}. Valid range is 1..8"
    end
  end
rescue Interrupt => _e
  cleanup_thread.kill
  channel.close
  connection.close
  exit(0)
end