# frozen_string_literal: true

module Application
  module UseCase
    class CreateCategoryRequest < Dry::Struct
      attribute :name, Types::String
      attribute :description, Types::String.optional.default('')
      attribute :is_active, Types::Bool.optional.default(true)
    end

    class CreateCategoryResponse < Dry::Struct
      attribute :id, Types::UUID
    end

    class CreateCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto)
        category = Domain::Category.new(
          name: request_dto.name,
          description: request_dto.description,
          is_active: request_dto.is_active
        )

        @repository.save(category)

        CreateCategoryResponse.new(id: category.id)
      rescue ArgumentError => e
        raise(Exceptions::InvalidCategoryData, e)
      end
    end
  end
end
