module Application
  module UseCase
    class ListGenreRequest < ApplicationStruct
    end

    class GenreOutput < ApplicationStruct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :is_active, Types::Bool
      attribute :categories, Types::Array.of(Types::UUID)
    end

    class ListGenreResponse < ApplicationStruct
      attribute :data, Types::Array.of(GenreOutput)
    end

    class ListGenre
      def initialize(genre_repository:)
        @genre_repository = genre_repository
      end

      def execute(_request_dto)
        genres = @genre_repository.list

        data = genres.map do |genre|
          GenreOutput.new(
            id: genre.id,
            name: genre.name,
            is_active: genre.is_active,
            categories: genre.categories
          )
        end

        ListGenreResponse.new(data:)
      end
    end
  end
end
