# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordVideoRepository < Domain::GenreRepository
      include Pagination

      def initialize(video_model: nil, genre_model: nil, category_model: nil, cast_member_model: nil,
                     audio_video_medium_model: nil)
        @video_model = video_model || Video
        @genre_model = genre_model || Genre
        @category_model = category_model || Category
        @cast_member_model = cast_member_model || CastMember
        @audio_video_medium_model = audio_video_medium_model || AudioVideoMedium

        @mapper = VideoMapper.new(
          video_model: @video_model,
          genre_model: @genre_model,
          category_model: @category_model,
          cast_member_model: @cast_member_model
        )
      end

      def save(video)
        video_record = @mapper.to_model(video)
        video_record.save!
      end

      def get_by_id(id:)
        video_record = @video_model.find(id)
        return if video_record.nil?

        @mapper.to_entity(video_record)
      end

      def delete(id:)
        video_record = @video_model.find_by(id:)
        video_record&.destroy!

        nil
      end

      def update(video)
        video_record = @video_model.find_by(id: video.id)

        # delete the associated video
        video_record.audio_video_medium&.destroy! if video.video

        # update the associations
        video_record.category_ids = video.categories
        video_record.genre_ids = video.genres
        video_record.cast_member_ids = video.cast_members

        # add the new video
        if video.video.present?
          video_record.audio_video_medium = @audio_video_medium_model.new(
            id: SecureRandom.uuid,
            video_id: video_record.id,
            name: video.video.name,
            raw_location: video.video.raw_location,
            encoded_location: video.video.encoded_location
          )
        end

        # update video attributes
        video_record.title = video.title
        video_record.description = video.description
        video_record.launch_year = video.launch_year
        video_record.duration = video.duration
        video_record.published = video.published
        video_record.rating = video.rating

        video_record.save!
      rescue ActiveRecord::RecordNotFound
        nil
      end

      def list(request_dto = nil)
        video = paginate(scope: @video_model.all, page: request_dto&.page, page_size: request_dto&.page_size)
        video = order_by(scope: video, order_by: request_dto&.order_by)

        video.map { |record| @mapper.to_entity(record) }
      end
    end
  end
end
