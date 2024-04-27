# frozen_string_literal: true

module Application
  module UseCase
    class ListCastMember
      def initialize(cast_member_repository:)
        @cast_member_repository = cast_member_repository
      end

      def execute(_request_dto)
        cast_members = @cast_member_repository.list

        data = cast_members.map do |cast_member|
          DTO::CastMemberOutput.new(
            id: cast_member.id,
            name: cast_member.name,
            type: cast_member.type
          )
        end

        DTO::ListCastMemberOutput.new(data:)
      end
    end
  end
end
