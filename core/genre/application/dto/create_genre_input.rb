# frozen_string_literal: true

module Application
  module DTO
    class CreateGenreInput < ApplicationStruct
      attribute :name, Types::String
      attribute :is_active, Types::Bool.optional.default(true)
      attribute :categories, Types::Array.optional.default([])
    end
  end
end
