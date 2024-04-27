# frozen_string_literal: true

module Application
  module DTO
    class CategoryOutput < ApplicationStruct
      attribute :id, Types::String
      attribute :name, Types::String
      attribute :description, Types::String
      attribute :is_active, Types::Bool
    end
  end
end
