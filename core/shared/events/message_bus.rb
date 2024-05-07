# frozen_string_literal: true

module Events
  class MessageBus < ApplicationMessageBus
    EVENT_TO_HANDLER = {
      Application::Events::AudioVideoMediumUpdatedIntegrationEvent => [
        Application::Handlers::PublishAudioVideoMedimUpdatedHandler
          .new(event_dispatcher: Infra::Events::RabbitMQDispatcher.new)
      ]
    }.freeze

    attr_reader :handlers

    def initialize
      @handlers = {}.merge(EVENT_TO_HANDLER)
    end

    def handle(events: [])
      events.each do |event|
        @handlers.fetch(event.class, []).each do |handler|
          handler.handle(event:)
        rescue StandardError => e
          Rails.logger.error(e)
        end
      end
    end
  end
end
