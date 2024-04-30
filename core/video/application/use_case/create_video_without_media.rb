# frozen_string_literal: true

module Application
  module UseCase
    class CreateVideoWithoutMedia
      def initialize(
        video_repository:,
        category_repository:,
        genre_repository:,
        cast_member_repository:
      )
        @video_repository = video_repository
        @category_repository = category_repository
        @genre_repository = genre_repository
        @cast_member_repository = cast_member_repository

        @notification = Notification.new
      end

      def execute(request_dto)
        validate_categories(request_dto)
        validate_genres(request_dto)
        validate_cast_members(request_dto)

        raise Exceptions::RelatedAssociationsNotFound, @notification.messages if @notification.errors?

        video = Domain::Video.new(
          title: request_dto.title,
          description: request_dto.description,
          launch_year: request_dto.launch_year,
          duration: request_dto.duration,
          published: false,
          rating: request_dto.rating,
          categories: request_dto.categories,
          genres: request_dto.genres,
          cast_members: request_dto.cast_members
        )

        @video_repository.save(video)

        Application::DTO::CreateVideoWithoutMediaOutput.new(id: video.id)
      end

      private

      def validate_categories(request_dto)
        categories_input = Application::DTO::ListCategoryInput.new
        categories = @category_repository.list(categories_input).map(&:id)

        missing = request_dto.categories - categories
        @notification.add_error("categories [#{missing.join(', ')}] not found") unless missing.empty?
      end

      def validate_genres(request_dto)
        genres_input = Application::DTO::ListGenreInput.new
        genres = @genre_repository.list(genres_input).map(&:id)

        missing = request_dto.genres - genres
        @notification.add_error("genres [#{missing.join(', ')}] not found") unless missing.empty?
      end

      def validate_cast_members(request_dto)
        cast_members_input = Application::DTO::ListCastMemberInput.new
        cast_members = @cast_member_repository.list(cast_members_input).map(&:id)

        missing = request_dto.cast_members - cast_members
        @notification.add_error("cast_members [#{missing.join(', ')}] not found") unless missing.empty?
      end
    end
  end
end
