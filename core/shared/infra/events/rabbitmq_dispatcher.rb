# frozen_string_literal: true

module Infra
  module Events
    class RabbitmqDispatcher
      def initialize(queue: 'videos.new')
        @queue = queue
      end

      def dispatch(events:)
        p "Dispatching event: #{events}"
      end
    end
  end
end
