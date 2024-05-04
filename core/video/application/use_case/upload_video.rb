# frozen_string_literal: true

module Application
  module UseCase
    class UploadVideo
      def initialize(video_repository:, storage:)
        @video_repository = video_repository
        @storage = storage || Infra::Storage::AbstractStorage.new

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

        audio_video_media = Domain::ValueObjects::AudioVideoMedium.new(
          name: input_dto.file_name,
          raw_location: file_path,
          encoded_location: '',
          status: Domain::ValueObjects::AudioVideoMedium::MEDIA_STATUS[:pending]
        )

        video.update_video_medium(audio_video_media)

        @video_repository.update(video)
      end
    end
  end
end
