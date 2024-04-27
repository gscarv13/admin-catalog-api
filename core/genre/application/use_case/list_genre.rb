module Application
  module UseCase
    class ListGenre
      def initialize(genre_repository:)
        @genre_repository = genre_repository
      end

      def execute(_request_dto)
        genres = @genre_repository.list

        data = genres.map do |genre|
          DTO::GenreOutput.new(
            id: genre.id,
            name: genre.name,
            is_active: genre.is_active,
            categories: genre.categories
          )
        end

        DTO::ListGenreOutput.new(data:)
      end
    end
  end
end
