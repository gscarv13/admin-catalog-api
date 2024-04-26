# frozen_string_literal: true

module Application
  module UseCase
    class DeleteGenre
      def initialize(genre_repository:)
        @genre_repository = genre_repository
      end

      def execute(request_dto)
        genre = @genre_repository.get_by_id(id: request_dto.id)

        raise Exceptions::GenreNotFound.new(id: request_dto.id) if genre.nil?

        @genre_repository.delete(id: genre.id)
      end
    end
  end
end
