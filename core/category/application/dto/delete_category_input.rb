# frozen_string_literal: true

module Application
  module Dto
    class DeleteCategoryInput < ApplicationStruct
      attribute :id, Types::UUID
    end
  end
end
