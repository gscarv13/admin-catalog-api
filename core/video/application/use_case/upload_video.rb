# frozen_string_literal: true

module Application
  module UseCase
    class UploadVideo
      def initialize(video_repository:, storage:, message_bus:)
        @video_repository = video_repository
        @storage = storage || Infra::Storage::AbstractStorage.new
        @message_bus = message_bus || Events::MessageBus.new

        @notification = Notification.new
      end

      def execute(input_dto)
        video = @video_repository.get_by_id(id: input_dto.video_id)
        raise Exceptions::VideoNotFound, 'Video not found' if video.nil?

        file_path = "/videos/#{input_dto.video_id}/#{input_dto.file_name}"

        @storage.store(
          file_path:,
          content: input_dto.content,
          content_type: input_dto.content_type
        )

        audio_video_medium = Domain::ValueObjects::AudioVideoMedium.new(
          name: input_dto.file_name,
          raw_location: file_path,
          encoded_location: '',
          status: :pending,
          medium_type: :video
        )

        video.update_video_medium(audio_video_medium)

        @video_repository.update(video)

        # dispatch event
        event = Events::AudioVideoMediumUpdatedIntegrationEvent.new(
          resource_id: "#{video.id}.#{audio_video_medium.medium_type}",
          file_path: audio_video_medium.raw_location
        )

        @message_bus.handle(events: [event])
      end
    end
  end
end
