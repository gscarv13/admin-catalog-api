# frozen_string_literal: true

require_relative '../../../../../src/core/category/domain/category'
require_relative '../../../../spec_helper'

RSpec.describe Category do
  it 'should throw ArgumentError if name is missing' do
    expect { Category.new }.to(raise_error(ArgumentError, 'missing keyword: :name'))
  end

  it 'should raise error if name is more than 255 characters' do
    expect { Category.new(name: 'a' * 256) }
      .to(raise_error(ArgumentError, 'name must be less than 256 characters'))
  end

  it 'should raise error if name nil' do
    expect { Category.new(name: nil) }
      .to(raise_error(ArgumentError, 'name must be present'))
  end

  it 'should raise error if name empty' do
    expect { Category.new(name: '') }
      .to(raise_error(ArgumentError, 'name must be present'))
  end

  it 'when id is not specified and uuid should be generated' do
    uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/
    category = Category.new(name: 'Yes man')

    expect(uuid_regex.match?(category.id)).to(eq(true))
  end

  context '#update_category' do
    it 'updates category object with name and description' do
      category = Category.new(name: 'Moooovie', description: 'A very niiiiice movie')
      category.update_category(name: 'TV Show', description: 'A thrilling TV show')

      expect(category.name).to(eq('TV Show'))
      expect(category.description).to(eq('A thrilling TV show'))
    end

    it 'does not updates category object with invalid name' do
      category = Category.new(name: 'Moooovie', description: 'A very niiiiice movie')

      expect do
        category.update_category(name: 'a' * 256, description: 'A thrilling TV show')
      end.to(raise_error(ArgumentError, 'name must be less than 256 characters'))
    end

    it 'does not updates category object with invalid name' do
      category = Category.new(name: 'Moooovie', description: 'A very niiiiice movie')

      expect do
        category.update_category(name: '', description: 'A thrilling TV show')
      end.to(raise_error(ArgumentError, 'name must be present'))
    end
  end

  context '#activate' do
    it 'sets is_active to true' do
      category = Category.new(
        name: 'Moooovie',
        description: 'A very niiiiice movie',
        is_active: false
      )

      category.activate

      expect(category.is_active).to(eq(true))
    end
  end

  context '#deactivate' do
    it 'sets is_active to true' do
      category = Category.new(
        name: 'Moooovie',
        description: 'A very niiiiice movie'
      )

      category.deactivate

      expect(category.is_active).to(eq(false))
    end
  end

  context '#equal?' do
    it 'returns true if ids are equal' do
      id = SecureRandom.uuid_v4
      category = Category.new(id:, name: 'Moooovie', description: 'A very niiiiice movie')
      category2 = Category.new(id:, name: 'Moooovie', description: 'A very niiiiice movie')

      expect(category.equal?(category2)).to(eq(true))
    end

    it 'returns false if ids are not equal' do
      category = Category.new(name: 'Moooovie', description: 'A very niiiiice movie')
      category2 = Category.new(name: 'Moooovie', description: 'A very niiiiice movie')

      expect(category.equal?(category2)).to(eq(false))
    end

    it 'returns false if the object class is not equal' do
      id = SecureRandom.uuid_v4

      category = Category.new(id:, name: 'Moooovie', description: 'A very niiiiice movie')
      dummy = Struct.new(:id).new(id)

      expect(category.equal?(dummy)).to(eq(false))
    end
  end
end
