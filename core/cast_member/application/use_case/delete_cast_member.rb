# frozen_string_literal: true

module Application
  module UseCase
    class DeleteCastMemberRequest < ApplicationStruct
      attribute :id, Types::UUID
    end

    class DeleteCastMember
      def initialize(cast_member_repository:)
        @cast_member_repository = cast_member_repository
      end

      def execute(request_dto)
        cast_member = @cast_member_repository.get_by_id(id: request_dto.id)

        raise Exceptions::CastMemberNotFound.new(id: request_dto.id) if cast_member.nil?

        @cast_member_repository.delete(id: cast_member.id)
      end
    end
  end
end
