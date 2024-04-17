# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordGenreRepository < Domain::GenreRepository
      def initialize(genre_model: nil, category_model: nil)
        @genre_model = genre_model || Infra::Model::Genre
        @category_model = category_model || Infra::Model::Category
      end

      def save(genre)
        categories = genre.categories.map do |id|
          @category_model.find_by(id:) || raise(Exceptions::CategoryNotFound.new(id:))
        end

        @genre_model.create!(**genre.to_h, categories:)
      end

      def get_by_id(id:)
        record = @genre_model.find_by(id:)

        return if record.nil?

        Domain::Genre.new(
          id: record.id,
          name: record.name,
          categories: record.categories.pluck(:id),
          is_active: record.is_active
        )
      end

      def delete(id:)
        persisted_genre = @genre_model.find_by(id:)
        persisted_genre&.destroy!

        nil
      end

      def update(genre:)
        persisted_genre = @genre_model.find_by(id: genre.id)

        categories = genre.categories.map do |id|
          @category_model.find_by(id:) || raise(Exceptions::CategoryNotFound.new(id:))
        end

        persisted_genre.update!(**genre.to_h, categories:)
      end

      def list
        records = @genre_model.all

        records.map do |record|
          Domain::Genre.new(
            id: record.id,
            name: record.name,
            categories: record.categories.pluck(:id),
            is_active: record.is_active
          )
        end
      end
    end
  end
end
