# frozen_string_literal: true

module Infra
  module Repository
    class CastMemberMapper
      def initialize(cast_member_model: nil)
        @cast_member_model = cast_member_model || CastMember
      end

      def to_entity(model)
        Domain::CastMember.new(
          id: model.id,
          name: model.name,
          type: model.type
        )
      end

      def to_model(entity)
        @cast_member_model.new(
          id: entity.id,
          name: entity.name,
          type: entity.type
        )
      end

      def entity_to_hash(entity)
        {
          id: entity.id,
          name: entity.name,
          type: entity.type
        }
      end
    end
  end
end
