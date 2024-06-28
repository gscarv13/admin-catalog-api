# frozen_string_literal: true

module Infra
  module Consumer
    class VideoConvertedConsumer
      def initialize(hostname: 'localhost', queue_name: 'videos.converted')
        @connection = Bunny.new(hostname:).start
        @channel = @connection.create_channel
        @queue = @channel.queue(queue_name)
        @logger = Logger.new($stdout)
      end

      # body example
      # {
      #   "message": {
      #     "resource_id": "f11080e0-6207-4dc0-b32f-c1beb60be357.VIDEO",
      #     "file_path": "/videos/file.mp4"
      #   },
      #   "status": "pending",
      #   "error": "Error goes here"
      # }

      def consume
        puts ' [...] Waiting for messages. To exit press CTRL+C'
        @queue.subscribe(block: true) do |_delivery_info, _properties, body|
          puts " [-->] Received #{body}"
          message = JSON.parse(body)

          error_mesassage = message['error']

          if error_mesassage.present?
            resource_id = message['message']['resource_id'].split('.').first
            puts("Error processing video #{resource_id}: #{error_mesassage}")

            next
          end

          resource_id, medium_type = message['message']['resource_id'].split('.')
          encoded_location = message['message']['file_path']
          status = message['status']

          input = ::Application::DTO::ProcessAudioVideoMediumInput.new(
            video_id: resource_id,
            encoded_location:,
            status:,
            medium_type:
          )

          use_case = ::Application::UseCase::ProcessAudioVideoMedium.new(
            video_repository: Infra::Repository::ActiveRecordVideoRepository.new
          )

          use_case.execute(input)
        end
      rescue StandardError => e
        id = message.dig('message', 'resource_id')
        puts("[!!!] StandardError: error while processing message #{id} : #{e}")
      rescue Interrupt => e
        connection.close
        id = message.dig('message', 'resource_id')
        puts("[!!!] InterruptError: error while processing message #{id} : #{e}")
        exit(0)
      end
    end
  end
end
