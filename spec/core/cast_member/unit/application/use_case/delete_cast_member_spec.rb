# frozen_string_literal: true

RSpec.describe Application::UseCase::DeleteCastMember do
  it 'should delete cast_member from repository' do
    cast_member = Domain::CastMember.new(name: 'John Doe', type: 'actor')
    cast_member_repository = instance_double(Domain::CastMemberRepository, delete: nil, get_by_id: cast_member)
    use_case = Application::UseCase::DeleteCastMember.new(cast_member_repository:)
    request_dto = Application::DTO::DeleteCastMemberInput.new(id: cast_member.id)
    use_case.execute(request_dto)

    expect(cast_member_repository).to(have_received(:delete).with(id: cast_member.id))
  end

  it 'raises an error when cast_member is not found' do
    not_found_id = SecureRandom.uuid
    cast_member_repository = instance_double(Domain::CastMemberRepository, delete: nil, get_by_id: nil)
    use_case = Application::UseCase::DeleteCastMember.new(cast_member_repository:)
    request_dto = Application::DTO::DeleteCastMemberInput.new(id: not_found_id)

    expect { use_case.execute(request_dto) }.to(raise_error(
                                                  Exceptions::CastMemberNotFound,
                                                  "Cast member with id #{not_found_id} not found"
                                                ))
  end
end
