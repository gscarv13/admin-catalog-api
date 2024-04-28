# frozen_string_literal: true

module Application
  module DTO
    class CreateVideoWithoutMediaInput < ApplicationStruct
      attribute :title, Types::String
      attribute :description, Types::String
      attribute :launch_year, Types::Integer
      attribute :duration, Types::Decimal
      attribute :rating, Types::String

      attribute :categories, Types::Array.of(Types::UUID)
      attribute :genres, Types::Array.of(Types::UUID)
      attribute :cast_members, Types::Array.of(Types::UUID)
    end
  end
end
