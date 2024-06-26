# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::UpdateCastMember do
  it 'when cast member does not exist should raise error' do
    cast_member_repository = instance_double(Domain::CastMemberRepository, get_by_id: nil)

    use_case = Application::UseCase::UpdateCastMember.new(cast_member_repository:)
    request_dto = Application::DTO::UpdateCastMemberInput.new(
      id: SecureRandom.uuid,
      name: 'Rosalin',
      type: 'actor'
    )

    expect { use_case.execute(request_dto) }.to(
      raise_error(Exceptions::CastMemberNotFound,
                  "Cast member with id #{request_dto.id} not found")
    )
  end

  it 'when cast_member request has invalid params should raise invalid cast_member error' do
    cast_member = Domain::CastMember.new(name: 'Rosalin', type: 'actor')
    cast_member_repository = instance_double(Domain::CastMemberRepository, get_by_id: cast_member)

    use_case = Application::UseCase::UpdateCastMember.new(cast_member_repository:)
    request_dto = Application::DTO::UpdateCastMemberInput.new(
      id: cast_member.id,
      name: '',
      type: ''
    )

    expect { use_case.execute(request_dto) }.to(
      raise_error(
        Exceptions::InvalidCastMemberData,
        'name ["must be filled"], type ["must be filled"]'
      )
    )
  end

  it 'should update cast_member from cast_member_repository' do
    cast_member = Domain::CastMember.new(name: 'Rosalllin', type: 'actor')
    cast_member_repository = instance_double(Domain::CastMemberRepository, get_by_id: cast_member, update: nil)

    expect(cast_member_repository.get_by_id(id: cast_member.id)).to(eq(cast_member))

    use_case = Application::UseCase::UpdateCastMember.new(cast_member_repository:)

    request_dto = Application::DTO::UpdateCastMemberInput.new(
      id: cast_member.id,
      name: 'Rosalin',
      type: 'director'
    )

    use_case.execute(request_dto)

    expect(cast_member_repository).to(
      have_received(:update).with(
        Domain::CastMember.new(
          id: cast_member.id,
          name: 'Rosalin',
          type: 'director'
        )
      )
    )
  end
end
