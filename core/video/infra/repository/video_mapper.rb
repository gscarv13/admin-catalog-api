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
        @video_model.new(
          id: entity.id,
          title: entity.title,
          description: entity.description,
          launch_year: entity.launch_year,
          duration: entity.duration,
          published: entity.published,
          rating: entity.rating,
          category_ids: entity.categories,
          genre_ids: entity.genres,
          cast_member_ids: entity.cast_members
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
          category_ids: entity.categories,
          genre_ids: entity.genres,
          cast_member_ids: entity.cast_members
        }
      end
    end
  end
end
