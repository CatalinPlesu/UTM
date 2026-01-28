# frozen_string_literal: true

require 'bunny'
require 'digest/sha2'
require 'json'

user = 'guest'
password = 'guest'
host = 'rabbitmq:5672'
queue_name = 'crypto-puzzle-inquiries'

def solve_crypto_puzzle(string, difficulty)
  sha256 = Digest::SHA256.new
  needle = '0' * difficulty
  solution_candidate = nil
  n = 0
  loop do
    solution_candidate = string + n.to_s
    result = sha256.hexdigest(solution_candidate)
    return solution_candidate if result[0...difficulty] == needle
    n += 1
  end
end

connection = Bunny.new "amqp://#{user}:#{password}@#{host}"
connection.start

channel = connection.create_channel
exchange = channel.default_exchange
queue = channel.queue(queue_name, auto_delete: true)
begin
  queue.subscribe(block: true) do |_delivery_info, properties, payload|
    json_payload = JSON.parse(payload)
    string = json_payload['string']
    difficulty = json_payload['difficulty']
    solution = solve_crypto_puzzle(string, difficulty)

    exchange.publish(
      solution,
      routing_key: properties.reply_to,
      correlation_id: properties.correlation_id
    )

  end
rescue Interrupt => _e
  channel.close
  connection.close
  exit(0)
end
