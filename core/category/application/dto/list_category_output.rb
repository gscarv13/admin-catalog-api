# frozen_string_literal: true

module Application
  module DTO
    class ListCategoryOutput < ApplicationStruct
      attribute :data, Types::Array.of(CategoryOutput)

      attribute :meta, Types::Hash.schema(
        current_page: Types::Integer,
        page_size: Types::Integer,
        total: Types::Integer
      )
    end
  end
end
