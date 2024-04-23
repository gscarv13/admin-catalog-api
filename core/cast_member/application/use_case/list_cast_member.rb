# frozen_string_literal: true

module Application
  module UseCase
    class ListCastMemberRequest < Dry::Struct
    end

    class CastMemberOutput < Dry::Struct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :type, Types::String
    end

    class ListCastMemberResponse < Dry::Struct
      attribute :data, Types::Array.of(CastMemberOutput)
    end

    class ListCastMember
      def initialize(cast_member_repository:)
        @cast_member_repository = cast_member_repository
      end

      def execute(_request_dto)
        cast_members = @cast_member_repository.list

        data = cast_members.map do |cast_member|
          CastMemberOutput.new(
            id: cast_member.id,
            name: cast_member.name,
            type: cast_member.type
          )
        end

        ListCastMemberResponse.new(data:)
      end
    end
  end
end
