# frozen_string_literal: true

module Application
  module UseCase
    class CreateGenreRequest < Dry::Struct
      attribute :name, Types::String
      attribute :is_active, Types::Bool.optional.default(true)
      attribute :categories, Types::Array.optional.default([])
    end

    class CreateGenreResponse < Dry::Struct
      attribute :id, Types::UUID
    end

    class CreateGenre
      def initialize(genre_repository:, category_repository:)
        @genre_repository = genre_repository
        @category_repository = category_repository
      end

      def execute(request_dto)
        categories = @category_repository.list.map(&:id)

        missing = request_dto.categories - categories
        raise Exceptions::RelatedCategoriesNotFound.new(ids: missing) unless missing.empty?

        genre = Domain::Genre.new(
          name: request_dto.name,
          categories: request_dto.categories,
          is_active: request_dto.is_active
        )

        @genre_repository.save(genre)

        CreateGenreResponse.new(id: genre.id)
      rescue ArgumentError => e
        raise Exceptions::InvalidGenreData, e.message
      end
    end
  end
end
