# frozen_string_literal: true

module Application
  module Dto
    class ListCategoryInput < ApplicationStruct
      attribute :order_by, Types::String.default('name')
      attribute :page, Types::Integer.default(1)
      attribute :page_size, Types::Integer.default(10)
    end
  end
end
