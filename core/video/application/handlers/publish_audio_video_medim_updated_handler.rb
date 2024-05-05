# frozen_string_literal: true

module Application
  module Handlers
    class PublishAudioVideoMedimUpdatedHandler
      def initialize(event_dispatcher:)
        @event_dispatcher = event_dispatcher
      end

      def handle(event:)
        p "Publishing PublishAudioVideoMedimUpdatedHandler: #{event}"
        @event_dispatcher.dispatch(event:)
      end
    end
  end
end
