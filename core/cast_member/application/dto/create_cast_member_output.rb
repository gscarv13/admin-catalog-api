# frozen_string_literal: true

module Application
  module DTO
    class CreateCastMemberOutput < ApplicationStruct
      attribute :id, Types::UUID
    end
  end
end
