# frozen_string_literal: true

module Application
  module UseCase
    class ListCategoryRequest < Dry::Struct
      include Dry.Types
    end

    class CategoryOutput < Dry::Struct
      attribute :id, Types::String
      attribute :name, Types::String
      attribute :description, Types::String
      attribute :is_active, Types::Bool
    end

    class ListCategoryResponse < Dry::Struct
      attribute :data, Types::Array.of(CategoryOutput)
    end

    class ListCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(_request_dto)
        categories = @repository.list

        data = categories.map do |category|
          CategoryOutput.new(
            id: category.id,
            name: category.name,
            description: category.description,
            is_active: category.is_active
          )
        end

        ListCategoryResponse.new(data:)
      end
    end
  end
end
