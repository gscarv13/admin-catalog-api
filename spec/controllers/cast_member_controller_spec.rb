# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::CastMembersController, type: :controller do
  let(:actor) { Domain::CastMember.new(name: 'Adel', type: 'actor') }
  let(:director) { Domain::CastMember.new(name: 'Rosalin', type: 'director') }

  context 'GET #index' do
    it 'should return empty list of cast members if nor record exists' do
      get :index

      expect(JSON.parse(response.body)).to(eq({ 'data' => [] }))
    end

    it 'should return list of cast members' do
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new

      cast_member_repository.save(actor)
      cast_member_repository.save(director)

      get :index

      expect(response.status).to(eq(200))
      expect(JSON.parse(response.body)).to(eq({ 'data' => [
                                                {
                                                  'id' => actor.id,
                                                  'name' => 'Adel',
                                                  'type' => 'actor'
                                                },
                                                {
                                                  'id' => director.id,
                                                  'name' => 'Rosalin',
                                                  'type' => 'director'
                                                }
                                              ] }))
    end
  end

  context 'POST #create' do
    it 'should create cast_member' do
      cast_member = {
        name: 'Tink',
        type: 'director'
      }

      post :create, params: cast_member

      cast_member_id = JSON.parse(response.body).dig('data', 'id')

      expect(response.status).to(eq(201))

      persisted_cast_member = Infra::Repository::ActiveRecordCastMemberRepository.new.get_by_id(id: cast_member_id)

      expect(persisted_cast_member.id).to(eq(cast_member_id))
      expect(persisted_cast_member.name).to(eq('Tink'))
      expect(persisted_cast_member.type).to(eq('director'))
    end

    it 'should return 422 when CastMember params are invalid' do
      cast_member = {
        "name": '',
        type: 'director'
      }

      post :create, params: cast_member

      expect(response.status).to(eq(422))
      expect(JSON.parse(response.body)).to(eq({ 'error' => 'name ["must be filled"]' }))
    end
  end

  context 'DELETE #destroy' do
    it 'should delete cast_member' do
      cast_member = Domain::CastMember.new(name: 'Tink', type: 'director')

      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new
      cast_member_repository.save(cast_member)

      expect(CastMember.count).to(eq(1))

      delete :destroy, params: { id: cast_member.id }

      expect(CastMember.count).to(eq(0))
      expect(response.status).to(eq(204))
    end

    it 'should return 404 if cast_member not found' do
      delete :destroy, params: { id: SecureRandom.uuid }

      expect(response.status).to(eq(404))
    end
  end

  context 'PUT #update' do
    let(:cast_member_id) { SecureRandom.uuid }

    before do
      cast_member = Domain::CastMember.new(id: cast_member_id, name: 'Tink', type: 'director')
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new

      cast_member_repository.save(cast_member)
    end

    it 'should update cast_member' do
      cast_member = {
        id: cast_member_id,
        name: 'Hanako',
        type: 'actor'
      }

      put :update, params: cast_member

      expect(response.status).to(eq(204))
    end

    it 'should return 400 when request data is invalid' do
      cast_member = {
        id: cast_member_id,
        name: '',
        type: 'actor'
      }

      put :update, params: cast_member

      expect(response.status).to(eq(422))
      expect(JSON.parse(response.body)).to(eq({ 'error' => 'name ["must be filled"]' }))
    end

    it 'should return 404 if cast_member not found' do
      invalid_id = SecureRandom.uuid
      cast_member = {
        id: invalid_id,
        name: 'Hanako',
        type: 'actor'
      }

      put :update, params: cast_member

      expect(response.status).to(eq(404))
      expect(JSON.parse(response.body)).to(eq({ 'error' => "Cast member with id #{invalid_id} not found" }))
    end
  end
end
