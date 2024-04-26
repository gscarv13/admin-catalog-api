# frozen_string_literal: true

module Application
  module Dto
    class GetCategoryInput < Dry::Struct
      attribute :id, Types::UUID
    end
  end
end
