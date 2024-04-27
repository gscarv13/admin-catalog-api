# frozen_string_literal: true

module Application
  module UseCase
    class ListCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto)
        categories = @repository.list(request_dto)

        data = categories.map do |category|
          DTO::CategoryOutput.new(
            id: category.id,
            name: category.name,
            description: category.description,
            is_active: category.is_active
          )
        end

        DTO::ListCategoryOutput.new(
          data:,
          meta: {
            current_page: request_dto.page,
            page_size: request_dto.page_size,
            total: data.size
          }
        )
      end
    end
  end
end
