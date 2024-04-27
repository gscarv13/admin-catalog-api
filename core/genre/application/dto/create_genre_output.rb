# frozen_string_literal: true

module Application
  module DTO
    class CreateGenreOutput < ApplicationStruct
      attribute :id, Types::UUID
    end
  end
end
