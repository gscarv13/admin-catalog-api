# frozen_string_literal: true

module Application
  module DTO
    class CreateCategoryInput < Dry::Struct
      attribute :name, Types::String
      attribute :description, Types::String.optional.default('')
      attribute :is_active, Types::Bool.optional.default(true)
    end
  end
end
