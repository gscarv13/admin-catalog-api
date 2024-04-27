# frozen_string_literal: true

module Application
  module UseCase
    class CreateCastMember
      def initialize(cast_member_repository:)
        @cast_member_repository = cast_member_repository
      end

      def execute(request_dto)
        category = Domain::CastMember.new(
          name: request_dto.name,
          type: request_dto.type
        )

        @cast_member_repository.save(category)

        DTO::CreateCastMemberOutput.new(id: category.id)
      rescue ArgumentError => e
        raise(Exceptions::InvalidCastMemberData, e)
      end
    end
  end
end
