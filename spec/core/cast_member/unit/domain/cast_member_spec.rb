# frozen_string_literal: true

RSpec.describe Domain::CastMember do
  it 'should raise error if name is nil' do
    expect { Domain::CastMember.new(name: nil, type: 'actor') }.to(
      raise_error(ArgumentError,
                  'name ["must be filled"]')
    )
  end

  it 'should raise error if name is empty' do
    expect { Domain::CastMember.new(name: '', type: 'actor') }.to(
      raise_error(ArgumentError,
                  'name ["must be filled"]')
    )
  end

  it 'should raise error if type is empty' do
    expect { Domain::CastMember.new(name: 'John Doe', type: nil) }.to(
      raise_error(ArgumentError,
                  'type ["must be filled"]')
    )
  end

  it 'should raise error if type is not actor or director' do
    expect { Domain::CastMember.new(name: 'John Doe', type: 'something') }.to(
      raise_error(ArgumentError,
                  'type ["must be either `actor` or `director`"]')
    )
  end

  it 'should add id if not provided' do
    cast_member = Domain::CastMember.new(name: 'John Doe', type: 'actor')

    expect(cast_member.id).not_to be_nil
    expect { Types::UUID[cast_member.id] }.not_to raise_error
  end

  context '#update' do
    it 'should update name' do
      cast_member = Domain::CastMember.new(name: 'John Doe', type: 'actor')

      cast_member.update(name: 'Jane Doe')

      expect(cast_member.name).to eq('Jane Doe')
    end
  end

  context '#==' do
    it 'should return true if cast members are equal' do
      id = SecureRandom.uuid

      cast_member = Domain::CastMember.new(id:, name: 'John Doe', type: 'actor')
      other = Domain::CastMember.new(id:, name: 'John Doe', type: 'actor')

      expect(cast_member == other).to eq(true)
    end
  end

  context '#to_h' do
    it 'should return hash representation of cast member' do
      cast_member = Domain::CastMember.new(name: 'John Doe', type: 'actor')

      expect(cast_member.to_h).to eq({
                                       id: cast_member.id,
                                       name: 'John Doe',
                                       type: 'ACTOR'
                                     })
    end
  end
end
