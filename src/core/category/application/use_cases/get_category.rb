# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types

  UUID = Types::String.constrained(
    format: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
  )
end

class GetCategoryRequest < Dry::Struct
  attribute :id, Types::UUID
end

class GetCategoryResponse < Dry::Struct
  attribute :id, Types::UUID
  attribute :name, Types::String
  attribute :description, Types::String
  attribute :is_active, Types::Bool
end

class GetCategory
  def initialize(repository:)
    @repository = repository
  end

  def execute(request_dto)
    category = @repository.get_by_id(id: request_dto.id)

    raise CategoryNotFound.new(id: request_dto.id) if category.nil?

    GetCategoryResponse.new(
      id: category.id,
      name: category.name,
      description: category.description,
      is_active: category.is_active
    )
  end
end
