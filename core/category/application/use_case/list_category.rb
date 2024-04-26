# frozen_string_literal: true

module Application
  module UseCase
    class ListCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto = ListCategoryRequest.new)
        categories = @repository.list(request_dto)

        data = categories.map do |category|
          Dto::CategoryOutput.new(
            id: category.id,
            name: category.name,
            description: category.description,
            is_active: category.is_active
          )
        end

        sorted_data = data.sort_by { |category| category.send(request_dto.order_by.to_sym) }
        Dto::ListCategoryOutput.new(
          data: sorted_data,
          meta: {
            current_page: request_dto.page,
            page_size: request_dto.page_size,
            total: sorted_data.size
          }
        )
      end
    end
  end
end
