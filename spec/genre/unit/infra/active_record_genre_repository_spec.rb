# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Infra::Repository::ActiveRecordGenreRepository do
  context '#save' do
    it 'should save a new genre' do
      repository = Infra::Repository::ActiveRecordGenreRepository.new
      genre = Domain::Genre.new(name: 'Adventure')

      expect(Infra::Model::Genre.count).to(eq(0))

      repository.save(genre)

      expect(Infra::Model::Genre.count).to(eq(1))

      genre_db = Infra::Model::Genre.find_by(id: genre.id)

      expect(genre_db.id).to(eq(genre.id))
      expect(genre_db.name).to(eq(genre.name))
      expect(genre_db.is_active).to(eq(true))
      expect(genre_db.categories).to(eq([]))
    end

    it 'should save a new genre with categories' do
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      category = Domain::Category.new(name: 'Documentary')

      category_repository.save(category)

      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      genre = Domain::Genre.new(
        name: 'Adventure',
        categories: [category.id]
      )

      expect(Infra::Model::Genre.count).to(eq(0))

      genre_repository.save(genre)

      expect(Infra::Model::Genre.count).to(eq(1))

      persisted_category = Infra::Model::Genre.find_by(id: genre.id)
                                              .categories.first.id

      expect(persisted_category).to(eq(category.id))
    end
  end

  context '#get_by_id' do
    it 'should return a genre by id' do
      genre = Domain::Genre.new(
        name: 'Horror',
        is_active: false
      )

      repository = Infra::Repository::ActiveRecordGenreRepository.new
      repository.save(genre)

      persisted_genre = repository.get_by_id(id: genre.id)

      expect(genre).to(be_a(Domain::Genre))

      expect(persisted_genre.id).to(eq(genre.id))
      expect(persisted_genre.name).to(eq(genre.name))
      expect(persisted_genre.is_active).to(eq(genre.is_active))
      expect(persisted_genre.categories).to(eq(genre.categories))
    end
  end

  context '#delete' do
    it 'should delete a genre' do
      genre = Domain::Genre.new(name: 'Fantasy', is_active: true)

      repository = Infra::Repository::ActiveRecordGenreRepository.new
      repository.save(genre)

      expect(Infra::Model::Genre.count).to(eq(1))

      result = repository.delete(id: genre.id)

      expect(Infra::Model::Genre.count).to(eq(0))
      expect(result).to(eq(nil))
    end

    it 'should return nil if genre is not found' do
      repository = Infra::Repository::ActiveRecordGenreRepository.new

      expect(repository.delete(id: 'invalid_id')).to(be_nil)
    end
  end

  context '#list' do
    it 'should list all genres' do
      repository = Infra::Repository::ActiveRecordGenreRepository.new

      expect(repository.list.size).to(eq(0))

      action_genre = Domain::Genre.new(name: 'Action')
      animation_genre = Domain::Genre.new(name: 'Animation')

      repository.save(action_genre)
      repository.save(animation_genre)

      result = repository.list

      expect(result.size).to(eq(2))
      expect(result.first == action_genre).to(eq(true))
      expect(result.last == animation_genre).to(eq(true))
    end
  end

  context '#update' do
    it 'should update a category' do
      genre = Domain::Genre.new(name: 'Biography')

      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      genre_repository.save(genre)

      current_genre = Infra::Model::Genre.find_by(id: genre.id)

      expect(current_genre.name).to(eq('Biography'))

      category = Domain::Category.new(name: 'Documentary')
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      category_repository.save(category)

      genre.name = 'Mystery'
      genre.categories = [category.id]

      genre_repository.update(genre)

      updated_genre = Infra::Model::Genre.find_by(id: genre.id)

      expect(updated_genre.id).to(eq(current_genre.id))
      expect(updated_genre.name).to(eq('Mystery'))
      expect(updated_genre.categories.size).to(eq(1))
      expect(updated_genre.categories.last.id).to(eq(category.id))
    end
  end
end
