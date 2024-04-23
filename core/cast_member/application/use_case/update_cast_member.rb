# frozen_string_literal: true

module Application
  module UseCase
    class UpdateCastMemberRequest < Dry::Struct
      attribute :id, Types::UUID
      attribute :name, Types::String
      attribute :type, Types::String
    end

    class UpdateCastMember
      def initialize(cast_member_repository:)
        @cast_member_repository = cast_member_repository
      end

      def execute(request_dto)
        cast_member = @cast_member_repository.get_by_id(id: request_dto.id)
        raise Exceptions::CastMemberNotFound.new(id: request_dto.id) if cast_member.nil?

        cast_member_name = cast_member.name
        cast_member_name = request_dto.name if request_dto.name

        cast_member_type = cast_member.type
        cast_member_type = request_dto.type if request_dto.type

        updated_cast_member = Domain::CastMember.new(
          id: cast_member.id,
          name: cast_member_name,
          type: cast_member_type
        )

        @cast_member_repository.update(updated_cast_member)
      rescue ArgumentError => e
        raise(Exceptions::InvalidCastMemberData, e)
      end
    end
  end
end
