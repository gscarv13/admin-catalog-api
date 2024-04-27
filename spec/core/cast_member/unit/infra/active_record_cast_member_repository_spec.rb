# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Infra::Repository::ActiveRecordCastMemberRepository do
  context '#save' do
    it 'should save a new cast_member' do
      repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      cast_member = Domain::CastMember.new(name: 'Prinny', type: 'actor')

      expect(CastMember.count).to(eq(0))

      repository.save(cast_member)

      expect(CastMember.count).to(eq(1))

      cast_member_db = CastMember.find_by(id: cast_member.id)

      expect(cast_member_db.id).to(eq(cast_member.id))
      expect(cast_member_db.name).to(eq(cast_member.name))
      expect(cast_member_db.type).to(eq(cast_member.type))
    end
  end

  context '#get_by_id' do
    it 'should return a cast_member by id' do
      cast_member = Domain::CastMember.new(name: 'Tink', type: 'director')

      repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      repository.save(cast_member)

      persisted_cast_member = repository.get_by_id(id: cast_member.id)

      expect(cast_member).to(be_a(Domain::CastMember))

      expect(persisted_cast_member.id).to(eq(cast_member.id))
      expect(persisted_cast_member.name).to(eq(cast_member.name))
      expect(persisted_cast_member.type).to(eq(cast_member.type))
    end
  end

  context '#delete' do
    it 'should delete a cast_member' do
      cast_member = Domain::CastMember.new(name: 'Rosalin', type: 'actor')

      repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      repository.save(cast_member)

      expect(CastMember.count).to(eq(1))

      result = repository.delete(id: cast_member.id)

      expect(CastMember.count).to(eq(0))
      expect(result).to(eq(nil))
    end

    it 'should return nil if cast_member is not found' do
      repository = Infra::Repository::ActiveRecordCastMemberRepository.new

      expect(repository.delete(id: 'invalid_id')).to(be_nil)
    end
  end

  context '#list' do
    it 'should list all cast_members' do
      repository = Infra::Repository::ActiveRecordCastMemberRepository.new

      expect(repository.list.size).to(eq(0))

      actor_cast_member = Domain::CastMember.new(name: 'Rosalin', type: 'actor')
      director_cast_member = Domain::CastMember.new(name: 'Tink', type: 'director')

      repository.save(actor_cast_member)
      repository.save(director_cast_member)

      result = repository.list

      expect(result.size).to(eq(2))
      expect(result.first == actor_cast_member).to(eq(true))
      expect(result.last == director_cast_member).to(eq(true))
    end
  end

  context '#update' do
    it 'should update a category' do
      cast_member = Domain::CastMember.new(name: 'Etna', type: 'actor')

      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      cast_member_repository.save(cast_member)

      current_cast_member = CastMember.find_by(id: cast_member.id)

      expect(current_cast_member.name).to(eq('Etna'))
      expect(current_cast_member.type).to(eq('ACTOR'))

      cast_member.name = 'Adel'
      cast_member.type = 'DIRECTOR'
      cast_member_repository.update(cast_member)

      updated_cast_member = CastMember.find_by(id: cast_member.id)

      expect(updated_cast_member.id).to(eq(current_cast_member.id))
      expect(updated_cast_member.name).to(eq('Adel'))
      expect(updated_cast_member.type).to(eq('DIRECTOR'))
    end
  end
end
