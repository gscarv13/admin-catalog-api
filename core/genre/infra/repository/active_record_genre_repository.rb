# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordGenreRepository < Domain::GenreRepository
      include Pagination

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

        genre_attributes = @mapper.entity_to_hash(genre)
        persisted_genre.update!(**genre_attributes, categories:)
      end

      def list(request_dto = nil)
        genres = paginate(scope: @genre_model.all, page: request_dto&.page, page_size: request_dto&.page_size)
        genres = order_by(scope: genres, order_by: request_dto&.order_by)

        genres.map { |record| @mapper.to_entity(record) }
      end
    end
  end
end
