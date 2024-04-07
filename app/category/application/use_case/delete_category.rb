# frozen_string_literal: true

module Application
  module UseCase
    module Types
      include Dry.Types

      UUID = Types::String.constrained(format: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
    end

    class DeleteCategoryRequest < Dry::Struct
      attribute :id, Types::UUID
    end

    class DeleteCategory
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto)
        category = @repository.get_by_id(id: request_dto.id)

        raise Exceptions::CategoryNotFound.new(id: request_dto.id) if category.nil?

        @repository.delete(id: category.id)
      end
    end
  end
end
