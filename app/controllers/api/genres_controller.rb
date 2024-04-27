# frozen_string_literal: true

module Api
  class GenresController < ApplicationController
    def index
      page = params.fetch('page', nil)
      page_size = params.fetch('page_size', nil)
      order_by = params.fetch('order_by', nil)

      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      use_case = Application::UseCase::ListGenre.new(genre_repository:)
      input = Application::DTO::ListGenreInput.new(page:, page_size:, order_by:)
      output = use_case.execute(input)

      render json: {
        data: output.data
      }, status: :ok
    end

    def create
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      use_case = Application::UseCase::CreateGenre.new(genre_repository:, category_repository:)
      input = Application::DTO::CreateGenreInput.new(create_params)
      output = use_case.execute(input)

      render json: {
        data: output
      }, status: :created
    rescue Exceptions::RelatedCategoriesNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue Exceptions::InvalidGenreData => e
      render json: { error: e.message }, status: :unprocessable_entity
    end

    def destroy
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      use_case = Application::UseCase::DeleteGenre.new(genre_repository:)
      input = Application::DTO::DeleteGenreInput.new(id: params[:id])
      use_case.execute(input)

      head :no_content
    rescue Exceptions::GenreNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    def update
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      use_case = Application::UseCase::UpdateGenre.new(genre_repository:, category_repository:)
      input = Application::DTO::UpdateGenreInput.new(update_params)
      use_case.execute(input)

      head :no_content
    rescue Exceptions::CategoryNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue Exceptions::InvalidGenreData => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue Exceptions::GenreNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    private

    def update_params
      params.permit(:id, :name, :is_active, categories: [])
            .to_h
            .symbolize_keys
            .merge({ is_active: params[:is_active] == 'true' })
    end

    def create_params
      params.permit(:name, :is_active, categories: []).to_h.symbolize_keys
    end
  end
end
