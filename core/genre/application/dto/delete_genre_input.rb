# frozen_string_literal: true

module Application
  module DTO
    class DeleteGenreInput < ApplicationStruct
      attribute :id, Types::UUID
    end
  end
end
