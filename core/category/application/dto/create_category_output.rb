# frozen_string_literal: true

module Application
  module DTO
    class CreateCategoryOutput < Dry::Struct
      attribute :id, Types::UUID
    end
  end
end
