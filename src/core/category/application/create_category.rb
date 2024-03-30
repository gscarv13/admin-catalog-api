# frozen_string_literal: true

require 'dry-struct'

module Types
  include Dry.Types
end

# Input class
class CreateCategoryRequest < Dry::Struct
  attribute :name, Types::String
  attribute :description, Types::String.optional.default('')
  attribute :is_active, Types::Bool.optional.default(true)
end

# Output class
class CreateCategoryResponse < Dry::Struct
  attribute :id, Types::String
end

# Use case
class CreateCategory
  def initialize(repository:)
    @repository = repository
  end

  def execute(request_dto)
    category = Category.new(
      name: request_dto.name,
      description: request_dto.description,
      is_active: request_dto.is_active
    )

    @repository.save(category)

    category.id
  rescue ArgumentError => e
    raise(InvalidCategoryData, e)
  end
end
