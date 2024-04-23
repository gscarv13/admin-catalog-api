# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordCastMemberRepository < Domain::CastMemberRepository
      def initialize(cast_member_model: nil)
        @cast_member_model = cast_member_model || CastMember
      end

      def save(cast_member)
        params = cast_member.to_h.merge(role_type: cast_member.type)
        params.delete(:type)

        @cast_member_model.create!(**params)
      end

      def get_by_id(id:)
        record = @cast_member_model.find_by(id:)

        return if record.nil?

        Domain::CastMember.new(
          id: record.id,
          name: record.name,
          type: record.role_type
        )
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

        records.map do |record|
          Domain::CastMember.new(
            id: record.id,
            name: record.name,
            type: record.role_type
          )
        end
      end
    end
  end
end
