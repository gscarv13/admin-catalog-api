# frozen_string_literal: true

module Application
  module UseCase
    class CreateCastMemberRequest < Dry::Struct
      attribute :name, Types::String
      attribute :type, Types::String
    end

    class CreateCastMemberResponse < Dry::Struct
      attribute :id, Types::UUID
    end

    class CreateCastMember
      def initialize(repository:)
        @repository = repository
      end

      def execute(request_dto)
        category = Domain::CastMember.new(
          name: request_dto.name,
          type: request_dto.type
        )

        @repository.save(category)

        CreateCastMemberResponse.new(id: category.id)
      rescue ArgumentError => e
        raise(Exceptions::InvalidCastMemberData, e)
      end
    end
  end
end
