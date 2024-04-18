# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Controllers::Api::GenresController, type: :controller do
  let(:movie_category) { Domain::Category.new(name: 'Movie') }
  let(:tvshow_category) { Domain::Category.new(name: 'TV Show') }

  let(:horror_genre) { Domain::Genre.new(name: 'Horror', categories: [movie_category, tvshow_category]) }
  let(:mystery_genre) { Domain::Genre.new(name: 'Mystery', categories: [movie_category]) }

  context 'GET #index' do
    it 'should return empty list of genres if nor record exists' do
      get :index

      expect(JSON.parse(response.body)).to(eq({ 'data' => [] }))
    end

    it 'should return list of genres' do
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new

      category_repository.save(movie_category)
      category_repository.save(tvshow_category)

      genre_repository.save(horror_genre)
      genre_repository.save(mystery_genre)

      get :index

      expect(response.status).to(eq(200))
      expect(JSON.parse(response.body)).to(eq({ 'data' => [
                                                {
                                                  'id' => horror_genre.id,
                                                  'name' => 'Horror',
                                                  'is_active' => true,
                                                  'categories' => [movie_category.id, tvshow_category.id]
                                                },
                                                {
                                                  'id' => mystery_genre.id,
                                                  'name' => 'Mystery',
                                                  'is_active' => true,
                                                  'categories' => [movie_category.id]
                                                }
                                              ] }))
    end
  end

  context 'POST #create' do
    it 'should create genre' do
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new

      category_repository.save(movie_category)
      category_repository.save(tvshow_category)

      genre = {
        name: 'Drama',
        categories: [movie_category.id, tvshow_category.id]
      }

      post :create, params: genre

      genre_id = JSON.parse(response.body).dig('data', 'id')

      expect(response.status).to(eq(201))

      persisted_genre = Infra::Repository::ActiveRecordGenreRepository.new.get_by_id(id: genre_id)

      expect(persisted_genre.id).to(eq(genre_id))
      expect(persisted_genre.name).to(eq(genre[:name]))
      expect(persisted_genre.is_active).to(eq(true))
      expect(persisted_genre.categories).to(eq(genre[:categories]))
    end

    it 'should return 400 when related category id is not found' do
      not_found_category_id = SecureRandom.uuid
      genre = {
        "name": 'Drama',
        "categories": [not_found_category_id]
      }

      post :create, params: genre

      expect(response.status).to(eq(404))
      expect(JSON.parse(response.body)).to(eq({ 'error' => "Categories not found: #{not_found_category_id}" }))
    end

    it 'should return 422 when Genre params are invalid' do
      genre = {
        "name": ''
      }

      post :create, params: genre

      expect(response.status).to(eq(422))
      expect(JSON.parse(response.body)).to(eq({ 'error' => 'name must be present' }))
    end
  end

  context 'DELETE #destroy' do
    it 'should delete genre' do
      genre = Domain::Genre.new(name: 'Horror')

      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      genre_repository.save(genre)

      expect(Infra::Model::Genre.count).to(eq(1))

      delete :destroy, params: { id: genre.id }

      expect(Infra::Model::Genre.count).to(eq(0))
      expect(response.status).to(eq(204))
    end

    it 'should return 404 if genre not found' do
      delete :destroy, params: { id: SecureRandom.uuid }

      expect(response.status).to(eq(404))
    end
  end

  context 'PUT #update' do
    let(:genre_id) { SecureRandom.uuid }

    before do
      genre = Domain::Genre.new(id: genre_id, name: 'Horror')
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new

      genre_repository.save(genre)

      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      category_repository.save(movie_category)
      category_repository.save(tvshow_category)
    end

    it 'should update genre' do
      genre = {
        id: genre_id,
        name: 'Biography',
        is_active: true,
        categories: [movie_category.id, tvshow_category.id]
      }

      put :update, params: genre

      expect(response.status).to(eq(204))
    end

    it 'should return 400 when request data is invalid' do
      genre = {
        id: genre_id,
        name: '',
        is_active: true,
        categories: [movie_category.id]
      }

      put :update, params: genre

      expect(response.status).to(eq(422))
      expect(JSON.parse(response.body)).to(eq({ 'error' => 'name must be present' }))
    end

    it 'should return 404 if genre not found' do
      invalid_id = SecureRandom.uuid
      genre = {
        id: invalid_id,
        name: 'Biography',
        is_active: true,
        categories: [movie_category.id, tvshow_category.id]
      }

      put :update, params: genre

      expect(response.status).to(eq(404))
      expect(JSON.parse(response.body)).to(eq({ 'error' => "Genre with id #{invalid_id} not found" }))
    end

    it 'should return 422 when related category id is not found' do
      not_found_category_id = SecureRandom.uuid
      genre = {
        id: genre_id,
        name: 'Biography',
        is_active: false,
        categories: [movie_category.id, not_found_category_id]
      }

      put :update, params: genre

      expect(response.status).to(eq(404))
      expect(JSON.parse(response.body)).to(eq({ 'error' => "Category with id #{not_found_category_id} not found" }))
    end
  end
end
