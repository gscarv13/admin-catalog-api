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
      ).to_h.merge(duration: BigDecimal(params['duration']))
            .symbolize_keys
    end
  end
end
