# frozen_string_literal: true

module Application
  module Dto
    class ListCastMemberOutput < ApplicationStruct
      attribute :data, Types::Array.of(CastMemberOutput)
    end
  end
end
