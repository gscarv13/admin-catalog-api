# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    # GET /api/categories
    def index
      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      use_case = Application::UseCase::ListCategory.new(repository:)
      input = Application::DTO::ListCategoryInput.new(default_pagination_params)
      output = use_case.execute(input)

      render json: {
        data: output.data,
        meta: output.meta
      }
    end

    # GET /api/categories/:id
    def show
      return render json: { error: "invalid uuid #{params[:id]}" }, status: :bad_request unless validate_uuid

      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      use_case = Application::UseCase::GetCategory.new(repository:)
      input = Application::DTO::GetCategoryInput.new(id: params[:id])
      output = use_case.execute(input)

      render json: {
        data: output
      }
    rescue Exceptions::CategoryNotFound
      render json: { error: "category with id #{params[:id]} not found" }, status: :not_found
    end

    # POST /api/categories
    def create
      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      use_case = Application::UseCase::CreateCategory.new(repository:)
      input = Application::DTO::CreateCategoryInput.new(create_params)
      output = use_case.execute(input)

      render json: { data: output }, status: :created
    rescue Exceptions::InvalidCategoryData => e
      render json: { error: e.message }, status: :bad_request
    end

    # PUT /api/categories/:id
    def update
      return render json: { error: "invalid uuid #{params[:id]}" }, status: :bad_request unless validate_uuid

      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      use_case = Application::UseCase::UpdateCategory.new(repository:)
      input = Application::DTO::UpdateCategoryInput.new(update_params)
      use_case.execute(input)

      head :no_content
    rescue Exceptions::CategoryNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    def destroy
      return render json: { error: "invalid uuid #{params[:id]}" }, status: :bad_request unless validate_uuid

      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      use_case = Application::UseCase::DeleteCategory.new(repository:)
      input = Application::DTO::DeleteCategoryInput.new(id: params[:id])
      use_case.execute(input)

      head :no_content
    rescue Exceptions::CategoryNotFound => e
      render json: { error: e.message }, status: :not_found
    end

    private

    def create_params
      params.permit(:name, :description, :is_active)
            .to_h
            .symbolize_keys
    end

    def update_params
      params.permit(:id, :name, :description, :is_active)
            .to_h
            .symbolize_keys
            .merge({ is_active: params[:is_active] == 'true' })
    end

    def validate_uuid
      Types::UUID[params[:id]]

      true
    rescue Dry::Types::ConstraintError
      false
    end
  end
end
