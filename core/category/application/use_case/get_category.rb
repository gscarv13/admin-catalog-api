# frozen_string_literal: true

module Application
  module UseCase
    class GetCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto)
        category = @repository.get_by_id(id: request_dto.id)

        raise Exceptions::CategoryNotFound.new(id: request_dto.id) if category.nil?

        Dto::GetCategoryOutput.new(
          id: category.id,
          name: category.name,
          description: category.description,
          is_active: category.is_active
        )
      end
    end
  end
end
