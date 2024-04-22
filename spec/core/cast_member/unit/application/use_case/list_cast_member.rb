# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::ListCastMember do
  it 'should return an instance of ListCastMemberResponse' do
    repository = instance_double(Domain::CastMemberRepository, list: [])
    use_case = Application::UseCase::ListCastMember.new(cast_member_repository: repository)

    result = use_case.execute

    expect(result).to(be_a(Application::UseCase::ListCastMemberResponse))
  end

  it 'should return empty list if no cast members are found' do
    repository = instance_double(Domain::CastMemberRepository, list: [])
    use_case = Application::UseCase::ListCastMember.new(cast_member_repository: repository)

    result = use_case.execute

    expect(result.data).to(eq([]))
  end

  it 'should return list of cast members' do
    cast_member1 = Domain::CastMember.new(name: 'John Doe', type: 'actor')
    cast_member2 = Domain::CastMember.new(name: 'Jane Doe', type: 'director')

    repository = instance_double(Domain::CastMemberRepository, list: [cast_member1, cast_member2])
    use_case = Application::UseCase::ListCastMember.new(cast_member_repository: repository)

    result = use_case.execute
    expect(result.data).to(eq([
                                Application::UseCase::CastMemberOutput.new(
                                  id: cast_member1.id,
                                  name: 'John Doe',
                                  type: 'actor'
                                ),
                                Application::UseCase::CastMemberOutput.new(
                                  id: cast_member2.id,
                                  name: 'Jane Doe',
                                  type: 'director'
                                )
                              ]))
  end
end
