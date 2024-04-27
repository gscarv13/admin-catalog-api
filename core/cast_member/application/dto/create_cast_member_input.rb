# frozen_string_literal: true

module Application
  module DTO
    class CreateCastMemberInput < ApplicationStruct
      attribute :name, Types::String
      attribute :type, Types::String
    end
  end
end
