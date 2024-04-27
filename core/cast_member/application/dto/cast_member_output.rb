# frozen_string_literal: true

module Application
  module Dto
    class CastMemberOutput < ApplicationStruct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :type, Types::String
    end
  end
end