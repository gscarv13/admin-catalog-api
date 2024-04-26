# frozen_string_literal: true

module Application
  module UseCase
    class UpdateCategoryRequest < ApplicationStruct
      attribute :id, Types::UUID
      attribute :name, Types::String.optional.default(nil)
      attribute :description, Types::String.optional.default(nil)
      attribute :is_active, Types::Bool.optional.default(nil)
    end

    class UpdateCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto)
        category = @repository.get_by_id(id: request_dto.id)

        current_name = category.name
        current_description = category.description

        current_name = request_dto.name if request_dto.name
        current_description = request_dto.description if request_dto.description

        category.activate if request_dto.is_active
        category.deactivate unless request_dto.is_active

        category.update_category(name: current_name, description: current_description)

        @repository.update(category)
      end
    end
  end
end
