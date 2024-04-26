# frozen_string_literal: true

module Application
  module Dto
    class GenreOutput < ApplicationStruct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :is_active, Types::Bool
      attribute :categories, Types::Array.of(Types::UUID)
    end
  end
end
