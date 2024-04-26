# frozen_string_literal: true

module Application
  module UseCase
    class ListCategoryRequest < Dry::Struct
      transform_types do |type|
        if type.default?
          type.constructor do |value|
            value.nil? ? Dry::Types::Undefined : value
          end
        else
          type
        end
      end

      attribute :order_by, Types::String.default('name')
      attribute :page, Types::Integer.default(1)
      attribute :page_size, Types::Integer.default(10)
    end

    class CategoryOutput < Dry::Struct
      attribute :id, Types::String
      attribute :name, Types::String
      attribute :description, Types::String
      attribute :is_active, Types::Bool
    end

    class ListCategoryMeta < Dry::Struct
      attribute :current_page, Types::Integer
      attribute :page_size, Types::Integer
      attribute :total, Types::Integer.optional
    end

    class ListCategoryResponse < Dry::Struct
      attribute :data, Types::Array.of(CategoryOutput)

      attribute :meta, Types::Hash.schema(
        current_page: Types::Integer,
        page_size: Types::Integer,
        total: Types::Integer
      )
    end

    class ListCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto = ListCategoryRequest.new)
        categories = @repository.list(request_dto)

        data = categories.map do |category|
          CategoryOutput.new(
            id: category.id,
            name: category.name,
            description: category.description,
            is_active: category.is_active
          )
        end

        sorted_data = data.sort_by { |category| category.send(request_dto.order_by.to_sym) }
        ListCategoryResponse.new(
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
