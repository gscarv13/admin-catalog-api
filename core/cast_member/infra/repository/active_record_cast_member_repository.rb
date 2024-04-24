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
          type: model.role_type
        )
      end

      def to_model(entity)
        @cast_member_model.new(
          id: entity.id,
          name: entity.name,
          role_type: entity.type
        )
      end
    end

    class ActiveRecordCastMemberRepository < Domain::CastMemberRepository
      def initialize(cast_member_model: nil)
        @cast_member_model = cast_member_model || CastMember
        @mapper = CastMemberMapper.new(cast_member_model: @cast_member_model)
      end

      def save(cast_member)
        new_record = @mapper.to_model(cast_member)
        new_record.save!
      end

      def get_by_id(id:)
        record = @cast_member_model.find_by(id:)
        return if record.nil?

        @mapper.to_entity(record)
      end

      def delete(id:)
        persisted_cast_member = @cast_member_model.find_by(id:)
        persisted_cast_member&.destroy!

        nil
      end

      def update(cast_member)
        persisted_cast_member = @cast_member_model.find_by(id: cast_member.id)
        params = cast_member.to_h.merge(role_type: cast_member.type)
        params.delete(:type)

        persisted_cast_member.update!(**params)
      end

      def list
        records = @cast_member_model.all

        records.map { |record| @mapper.to_entity(record) }
      end
    end
  end
end
