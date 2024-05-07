# frozen_string_literal: true

module Infra
  module Events
    class RabbitMQDispatcher
      def initialize(hostname: 'localhost', queue_name: 'videos.new')
        @connection = Bunny.new(hostname:).start
        @channel = @connection.create_channel
        @queue = @channel.queue(queue_name)
      end

      def dispatch(event:)
        @channel.default_exchange.publish(
          event.to_json,
          routing_key: @queue.name
        )
      end
    end
  end
end
