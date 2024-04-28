# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordVideoRepository < Domain::GenreRepository
      include Pagination

      def initialize(video_repository: nil, genre_model: nil, category_model: nil, cast_member_model: nil)
        @video_repository = video_repository || Video
        @genre_model = genre_model || Genre
        @category_model = category_model || Category
        @cast_member_model = cast_member_model || CastMember

        @mapper = VideoMapper.new(
          video_model: @video_repository,
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
        video_record = @video_model.find_by(id:)
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

        categories = video.categories.map do |id|
          @category_model.find_by(id:) || raise(Exceptions::CategoryNotFound.new(id:))
        end

        genres = video.genres.map do |id|
          @genre_model.find_by(id:) || raise(Exceptions::GenreNotFound.new(id:))
        end

        cast_members = video.cast_members.map do |id|
          @cast_member_model.find_by(id:) || raise(Exceptions::CastMemberNotFound.new(id:))
        end

        video_attributes = @mapper.entity_to_hash(video)
        video_record.update!(**video_attributes, categories:, genres:, cast_members:)
      end

      def list(request_dto = nil)
        video = paginate(scope: @video_model.all, page: request_dto&.page, page_size: request_dto&.page_size)
        video = order_by(scope: video, order_by: request_dto&.order_by)

        video.map { |record| @mapper.to_entity(record) }
      end
    end
  end
end
