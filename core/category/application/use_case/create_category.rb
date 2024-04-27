# frozen_string_literal: true

module Application
  module UseCase
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

        DTO::CreateCategoryOutput.new(id: category.id)
      rescue ArgumentError => e
        raise(Exceptions::InvalidCategoryData, e)
      end
    end
  end
end
