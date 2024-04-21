# frozen_string_literal: true

module Infra
  module Repository
    class InMemoryGenreRepository < Domain::GenreRepository
      attr_reader :genres

      def initialize(genres: nil)
        @genres = genres || []
      end

      def save(genre)
        @genres << genre
      end

      def get_by_id(id:)
        @genres.find { |genre| genre.id == id }
      end

      def delete(id:)
        @genres.delete_if { |genre| genre.id == id }

        nil
      end

      def list
        @genres.dup
      end

      def update(genre)
        old_genre = get_by_id(id: genre.id)
        @genres.delete(old_genre)
        @genres << genre

        nil
      end
    end
  end
end
