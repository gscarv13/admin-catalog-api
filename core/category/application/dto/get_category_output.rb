# frozen_string_literal: true

module Application
  module Dto
    class GetCategoryOutput < Dry::Struct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :description, Types::String
      attribute :is_active, Types::Bool
    end
  end
end
