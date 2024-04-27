# frozen_string_literal: true

module Application
  module DTO
    class GetCategoryInput < Dry::Struct
      attribute :id, Types::UUID
    end
  end
end
