# frozen_string_literal: true

module Application
  module UseCase
    class ListCategoryRequest < Dry::Struct
      include Dry.Types
    end

    class CategoryOutput < Dry::Struct
      attribute :id, Domain::Types::String
      attribute :name, Domain::Types::String
      attribute :description, Domain::Types::String
      attribute :is_active, Domain::Types::Bool
    end

    class ListCategoryResponse < Dry::Struct
      attribute :data, Domain::Types::Array.of(CategoryOutput)
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
