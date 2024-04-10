# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::Genre do
  let(:uuid_regex) do
    /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
  end

  it 'should raise error if name is more than 255 characters' do
    expect { Domain::Genre.new(name: 'a' * 256) }
      .to(raise_error(ArgumentError, 'name must be less than 256 characters'))
  end

  it 'should raise error if name nil' do
    expect { Domain::Genre.new(name: nil) }
      .to(raise_error(ArgumentError, 'name must be present'))
  end

  it 'should raise error if name empty' do
    expect { Domain::Genre.new(name: '') }
      .to(raise_error(ArgumentError, 'name must be present'))
  end

  it 'when id is not specified and uuid should be generated' do
    genre = Domain::Genre.new(name: 'Horror')
    expect(uuid_regex.match?(genre.id)).to(eq(true))
  end

  it 'should create Genre with default values' do
    genre = Domain::Genre.new(name: 'Horror')

    expect(uuid_regex.match?(genre.id)).to(eq(true))
    expect(genre.categories).to(eq([]))
    expect(genre.is_active).to(eq(true))
  end

  it 'should create Genre with provided values' do
    categories = [SecureRandom.uuid, SecureRandom.uuid]
    genre = Domain::Genre.new(
      name: 'Drama',
      categories:,
      is_active: false
    )

    expect(uuid_regex.match?(genre.id)).to(eq(true))
    expect(genre.categories).to(eq(categories))
    expect(genre.is_active).to(eq(false))
  end

  context '#change_name' do
    it 'updates genre object name' do
      genre = Domain::Genre.new(name: 'Horror')
      expect(genre.name).to(eq('Horror'))

      genre.change_name('Psychodelic')
      expect(genre.name).to(eq('Psychodelic'))
    end

    it 'does not updates Genre object with invalid name' do
      genre = Domain::Genre.new(name: 'Horror')

      expect do
        genre.change_name('a' * 256)
      end.to(raise_error(ArgumentError, 'name must be less than 256 characters'))
    end

    it 'does not updates Genre object with empty name' do
      genre = Domain::Genre.new(name: 'Horror')

      expect do
        genre.change_name('')
      end.to(raise_error(ArgumentError, 'name must be present'))
    end
  end

  context '#activate' do
    it 'sets is_active to true' do
      genre = Domain::Genre.new(
        name: 'Horror',
        is_active: false
      )

      genre.activate

      expect(genre.is_active).to(eq(true))
    end
  end

  context '#deactivate' do
    it 'sets is_active to true' do
      genre = Domain::Genre.new(
        name: 'Horror'
      )

      genre.deactivate

      expect(genre.is_active).to(eq(false))
    end
  end

  context '#==?' do
    it 'returns true when all properties are equal' do
      id = SecureRandom.uuid_v4
      genre = Domain::Genre.new(id:, name: 'Horror', is_active: true, categories: [])
      genre2 = Domain::Genre.new(id:, name: 'Horror', is_active: true, categories: [])

      expect(genre == genre2).to(eq(true))
    end

    it 'returns false if some properties are not equal' do
      genre = Domain::Genre.new(name: 'Horror', is_active: true, categories: [])
      genre2 = Domain::Genre.new(name: 'Horror', is_active: true, categories: [])

      expect(genre == genre2).to(eq(false))
    end

    it 'returns false if the object class is not equal' do
      id = SecureRandom.uuid_v4

      genre = Domain::Genre.new(id:, name: 'Horror')
      dummy = Struct.new(:id).new(id)

      expect(genre == dummy).to(eq(false))
    end
  end
end
