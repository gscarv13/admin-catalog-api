# frozen_string_literal: true

module Application
  module UseCase
    class UpdateGenreRequest < Dry::Struct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :categories, Types::Array.of(Types::UUID)
      attribute :is_active, Types::Bool
    end

    class UpdateGenre
      def initialize(genre_repository:, category_repository:)
        @genre_repository = genre_repository
        @category_repository = category_repository
      end

      def execute(request_dto)
        genre = @genre_repository.get_by_id(id: request_dto.id)
        raise Exceptions::GenreNotFound.new(id: request_dto.id) if genre.nil?

        genre_name = genre.name
        genre_name = request_dto.name if request_dto.name

        genre_is_active = genre.is_active
        genre_is_active = request_dto.is_active if request_dto.is_active

        missing = []
        request_dto.categories.each do |id|
          category = @category_repository.get_by_id(id:)

          missing << id if category.nil?
        end

        raise Exceptions::RelatedCategoriesNotFound.new(ids: missing) unless missing.empty?

        genre_categories = genre.categories
        genre_categories = request_dto.categories if request_dto.categories

        updated_genre = Domain::Genre.new(
          id: genre.id,
          name: genre_name,
          categories: genre_categories,
          is_active: genre_is_active
        )

        @genre_repository.update(updated_genre)
      rescue ArgumentError => e
        raise(Exceptions::InvalidGenreData, e)
      end
    end
  end
end
