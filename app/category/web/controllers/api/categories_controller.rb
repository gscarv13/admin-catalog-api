# frozen_string_literal: true

module Web
  module Controllers
    module Api
      class CategoriesController < ApplicationController
        # GET /api/categories
        def index
          repository = Infra::Repository::ActiveRecordCategoryRepository.new
          use_case = Application::UseCase::ListCategory.new(repository:)
          input = Application::UseCase::ListCategoryRequest
          output = use_case.execute(input)

          render json: {
            data: output.data
          }
        end

        # GET /api/categories/:id
        def show
          return render json: { error: "invalid id #{params[:id]}" }, status: :bad_request unless validate_uuid

          repository = Infra::Repository::ActiveRecordCategoryRepository.new
          use_case = Application::UseCase::GetCategory.new(repository:)
          input = Application::UseCase::GetCategoryRequest.new(id: params[:id])
          output = use_case.execute(input)

          render json: {
            data: output
          }
        rescue Exceptions::CategoryNotFound
          render json: { error: "category with id #{params[:id]} not found" }, status: :not_found
        end

        private

        def validate_uuid
          Domain::Types::UUID[params[:id]]

          true
        rescue Dry::Types::ConstraintError
          false
        end
      end
    end
  end
end
