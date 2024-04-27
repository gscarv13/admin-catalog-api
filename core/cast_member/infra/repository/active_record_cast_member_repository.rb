# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordCastMemberRepository < Domain::CastMemberRepository
      include Pagination
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

      def list(request_dto = nil)
        cast_members = paginate(scope: @cast_member_model.all, page: request_dto&.page,
                                page_size: request_dto&.page_size)
        cast_members = order_by(scope: cast_members, order_by: request_dto&.order_by)

        cast_members.map { |record| @mapper.to_entity(record) }
      end
    end
  end
end
