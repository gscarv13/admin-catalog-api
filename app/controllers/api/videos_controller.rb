# frozen_string_literal: true

module Api
  class VideosController < ApplicationController
    def create
      video_repository = Infra::Repository::ActiveRecordVideoRepository.new
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new

      use_case = Application::UseCase::CreateVideoWithoutMedia.new(
        video_repository:,
        genre_repository:,
        category_repository:,
        cast_member_repository:
      )

      input = Application::DTO::CreateVideoWithoutMediaInput.new(create_params)
      output = use_case.execute(input)

      render json: { data: output }, status: :created
    rescue Exceptions::RelatedAssociationsNotFound => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def update
      file = params[:video_file]
      content = file.tempfile.read
      content_type = file.content_type
      file_name = file.original_filename.force_encoding('UTF-8')
      video_id = params[:id]

      video_repository = Infra::Repository::ActiveRecordVideoRepository.new
      storage = Infra::Storage::LocalStorage.new
      message_bus = Events::MessageBus.new

      use_case = Application::UseCase::UploadVideo.new(
        video_repository:, storage:, message_bus:
      )

      input = Application::DTO::UploadVideoInput.new(
        video_id:,
        file_name:,
        content_type:,
        content:
      )

      use_case.execute(input)
    rescue StandardError => e
      render json: { error: e.message }, status: :bad_request
    end

    private

    def create_params
      params.permit(
        :title,
        :description,
        :launch_year,
        :rating,
        :duration,
        genres: [],
        categories: [],
        cast_members: []
      ).to_h
            .merge(
              duration: BigDecimal(params['duration']),
              launch_year: params['launch_year'].to_i
            )
            .symbolize_keys
    end
  end
end
