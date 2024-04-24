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

    class ActiveRecordGenreRepository < Domain::GenreRepository
      def initialize(genre_model: nil, category_model: nil)
        @genre_model = genre_model || Genre
        @category_model = category_model || Category
        @mapper = GenreMapper.new(genre_model: @genre_model, category_model: @category_model)
      end

      def save(genre)
        genre_record = @mapper.to_model(genre)
        genre_record.save!
      end

      def get_by_id(id:)
        record = @genre_model.find_by(id:)
        return if record.nil?

        @mapper.to_entity(record)
      end

      def delete(id:)
        persisted_genre = @genre_model.find_by(id:)
        persisted_genre&.destroy!

        nil
      end

      def update(genre)
        persisted_genre = @genre_model.find_by(id: genre.id)

        categories = genre.categories.map do |id|
          @category_model.find_by(id:) || raise(Exceptions::CategoryNotFound.new(id:))
        end

        persisted_genre.update!(**genre.to_h, categories:)
      end

      def list
        records = @genre_model.all

        records.map { |record| @mapper.to_entity(record) }
      end
    end
  end
end
