# frozen_string_literal: true

module Application
  module Dto
    class UpdateCategoryInput < ApplicationStruct
      attribute :id, Types::UUID
      attribute :name, Types::String.optional.default(nil)
      attribute :description, Types::String.optional.default(nil)
      attribute :is_active, Types::Bool.optional.default(nil)
    end
  end
end
