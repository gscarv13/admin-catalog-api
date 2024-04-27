# frozen_string_literal: true

module Application
  module Dto
    class CreateCastMemberOutput < ApplicationStruct
      attribute :id, Types::UUID
    end
  end
end
