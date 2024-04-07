# frozen_string_literal: true

module Application
  module UseCase
    class CreateCategoryRequest < Dry::Struct
      attribute :name, Domain::Types::String
      attribute :description, Domain::Types::String.optional.default('')
      attribute :is_active, Domain::Types::Bool.optional.default(true)
    end

    class CreateCategoryResponse < Dry::Struct
      attribute :id, Domain::Types::UUID
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
