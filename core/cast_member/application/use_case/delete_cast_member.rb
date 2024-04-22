# frozen_string_literal: true

module Application
  module UseCase
    class DeleteCastMemberRequest < Dry::Struct
      attribute :id, Types::UUID
    end

    class DeleteCastMember
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto)
        cast_member = @repository.get_by_id(id: request_dto.id)

        raise Exceptions::CastMemberNotFound.new(id: request_dto.id) if cast_member.nil?

        @repository.delete(id: cast_member.id)
      end
    end
  end
end
