# frozen_string_literal: true

module Events
  class MessageBus < ApplicationMessageBus
    EVENT_TO_HANDLER = {
      Events::ApplicationEvent => [::ApplicationHandler]
    }.freeze

    attr_reader :handlers

    def initialize
      @handlers = {}
    end

    def handle(events: [])
      events.each do |event|
        @handlers[event].each do |handler|
          handler.new.handle(events: event)
        end
      end
    end
  end
end
