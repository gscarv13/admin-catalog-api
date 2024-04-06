# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Infra::Repository::ActiveRecordCategoryRepository do
  context '#save' do
    it 'should save a new category' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new

      category = Domain::Category.new(
        name: 'Moooovie',
        description: 'A very niiiiice movie',
        is_active: true
      )

      expect(Infra::Model::Category.count).to(eq(0))

      repository.save(category)

      expect(Infra::Model::Category.count).to(eq(1))

      category_db = Infra::Model::Category.find_by(id: category.id)

      expect(category_db.name).to(eq(category.name))
      expect(category_db.description).to(eq(category.description))
      expect(category_db.is_active).to(eq(category.is_active))
    end
  end

  context '#get_by_id' do
    it 'should return a category by id' do
      category = Domain::Category.new(
        name: 'Moooovie',
        description: 'A very niiiiice movie',
        is_active: true
      )

      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(category)

      category = repository.get_by_id(id: category.id)

      expect(category).to(be_a(Domain::Category))

      expect(category.id).to(eq(category.id))
      expect(category.name).to(eq(category.name))
      expect(category.description).to(eq(category.description))
      expect(category.is_active).to(eq(category.is_active))
    end
  end

  context '#delete' do
    it 'should delete a category' do
      category = Domain::Category.new(
        name: 'Moooovie',
        description: 'A very niiiiice movie',
        is_active: true
      )

      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(category)

      expect(Infra::Model::Category.count).to(eq(1))

      result = repository.delete(id: category.id)

      expect(Infra::Model::Category.count).to(eq(0))
      expect(result).to(eq(nil))
    end

    it 'should return nil if category is not found' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new

      expect(repository.delete(id: 'invalid_id')).to(be_nil)
    end
  end

  context '#list' do
    it 'should list all categories' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new

      expect(repository.list.size).to(eq(0))

      movie_category = Domain::Category.new(
        name: 'Moooovie',
        description: 'A very niiiiice movie',
        is_active: true
      )

      tv_show_category = Domain::Category.new(
        name: 'TV Show',
        description: 'A thrilling TV show',
        is_active: true
      )

      repository.save(movie_category)
      repository.save(tv_show_category)

      result = repository.list

      expect(result.size).to(eq(2))
      expect(result.first == movie_category).to(eq(true))
      expect(result.last == tv_show_category).to(eq(true))
    end
  end

  context '#update' do
    it 'should update a category' do
      category = Domain::Category.new(
        name: 'Moooovie',
        description: 'A very niiiiice movie',
        is_active: true
      )

      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(category)

      current_category = Infra::Model::Category.find_by(id: category.id)

      expect(current_category.name).to(eq('Moooovie'))
      expect(current_category.description).to(eq('A very niiiiice movie'))

      category.name = 'TV Show'
      category.description = 'A thrilling TV show'

      repository.update(category)

      updated_category = Infra::Model::Category.find_by(id: category.id)

      expect(updated_category.id).to(eq(current_category.id))
      expect(updated_category.name).to(eq('TV Show'))
      expect(updated_category.description).to(eq('A thrilling TV show'))
    end
  end
end
