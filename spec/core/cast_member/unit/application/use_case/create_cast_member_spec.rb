# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::CreateCastMember do
  let(:repository_double) { instance_double(Domain::CastMemberRepository, save: nil) }

  it 'should throw ArgumentError if name is missing' do
    use_case = Application::UseCase::CreateCastMember.new(cast_member_repository: repository_double)
    request_dto = Application::Dto::CreateCastMemberInput.new(name: '', type: 'actor')

    expect { use_case.execute(request_dto) }
      .to(raise_error(Exceptions::InvalidCastMemberData, 'name ["must be filled"]'))
  end

  it 'should throw ArgumentError if type is missing' do
    use_case = Application::UseCase::CreateCastMember.new(cast_member_repository: repository_double)
    request_dto = Application::Dto::CreateCastMemberInput.new(name: 'Adel', type: '')

    expect { use_case.execute(request_dto) }
      .to(raise_error(Exceptions::InvalidCastMemberData, 'type ["must be filled"]'))
  end

  it 'should create a new cast member with valid data' do
    uuid = '123e4567-e89b-12d3-a456-426614174000'
    allow(SecureRandom).to receive(:uuid).and_return(uuid)

    use_case = Application::UseCase::CreateCastMember.new(cast_member_repository: repository_double)
    request_dto = Application::Dto::CreateCastMemberInput.new(
      name: 'Kurtz',
      type: 'actor'
    )

    response_dto = use_case.execute(request_dto)

    expect(response_dto.id).to(eq(uuid))
    expect(repository_double).to(have_received(:save))
  end
end
