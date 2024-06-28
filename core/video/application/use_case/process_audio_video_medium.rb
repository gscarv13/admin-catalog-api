# frozen_string_literal: true

module Application
  module UseCase
    class ProcessAudioVideoMedium
      def initialize(video_repository:)
        @video_repository = video_repository
      end

      def execute(input_dto)
        video = @video_repository.get_by_id(id: input_dto.video_id)
        raise Exceptions::VideoNotFound, 'Video not found' if video.nil?

        if input_dto.medium_type == Domain::ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video]
          raise Exceptions::MediumNotFound, 'Video must have medium to be processed' unless video.video

          video.process(
            status: input_dto.status,
            encoded_location: input_dto.encoded_location
          )
        end

        @video_repository.update(video)
      end
    end
  end
end
