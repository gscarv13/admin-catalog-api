# frozen_string_literal: true

module Infra
  module Repository
    class GenreMapper
      def initialize(genre_model: nil, category_model: nil)
        @genre_model = genre_model || Genre
        @category_model = category_model || Category
      end

      def to_entity(model)
        Domain::Genre.new(
          id: model.id,
          name: model.name,
          categories: model.categories.pluck(:id),
          is_active: model.is_active
        )
      end

      def to_model(entity)
        categories = entity.categories.map do |id|
          @category_model.find_by(id:) || raise(Exceptions::CategoryNotFound.new(id:))
        end

        @genre_model.new(
          id: entity.id,
          name: entity.name,
          categories:,
          is_active: entity.is_active
        )
      end
    end
  end
end
