# frozen_string_literal: true

module Application
  module Dto
    class ListGenreOutput < ApplicationStruct
      attribute :data, Types::Array.of(GenreOutput)
    end
  end
end
