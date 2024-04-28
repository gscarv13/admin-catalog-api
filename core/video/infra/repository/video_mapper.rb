# frozen_string_literal: true

module Infra
  module Repository
    class VideoMapper
      def initialize(video_model: nil, genre_model: nil, category_model: nil, cast_member_model: nil)
        @video_model = video_model || Video
        @genre_model = genre_model || Genre
        @category_model = category_model || Category
        @cast_member_model = cast_member_model || CastMember
      end

      def to_entity(model)
        Domain::Video.new(
          id: model.id,
          title: model.title,
          description: model.description,
          launch_year: model.launch_year,
          duration: model.duration,
          published: model.published,
          rating: model.rating,
          categories: model.categories.pluck(:id),
          genres: model.genres.pluck(:id),
          cast_members: model.cast_members.pluck(:id)
        )
      end

      def to_model(entity)
        categories = entity.categories.map do |id|
          @category_model.find_by(id:) || raise(Exceptions::CategoryNotFound.new(id:))
        end

        genres = entity.genres.map do |id|
          @genre_model.find_by(id:) || raise(Exceptions::GenreNotFound.new(id:))
        end

        cast_members = entity.cast_members.map do |id|
          @cast_member_model.find_by(id:) || raise(Exceptions::CastMemberNotFound.new(id:))
        end

        @video_model.new(
          id: entity.id,
          title: entity.title,
          description: entity.description,
          launch_year: entity.launch_year,
          duration: entity.duration,
          published: entity.published,
          rating: entity.rating,
          categories:,
          genres:,
          cast_members:
        )
      end

      def entity_to_hash(entity)
        {
          id: entity.id,
          title: entity.title,
          description: entity.description,
          launch_year: entity.launch_year,
          duration: entity.duration,
          published: entity.published,
          rating: entity.rating,
          categories: entity.categories,
          genres: entity.genres,
          cast_members: entity.cast_members
        }
      end
    end
  end
end
