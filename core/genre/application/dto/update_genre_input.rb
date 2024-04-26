# frozen_string_literal: true

module Application
  module Dto
    class UpdateGenreInput < ApplicationStruct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :categories, Types::Array.of(Types::UUID)
      attribute :is_active, Types::Bool
    end
  end
end
