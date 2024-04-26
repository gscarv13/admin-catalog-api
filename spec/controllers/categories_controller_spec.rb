# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::CategoriesController, type: :controller do
  let(:movie_category) do
    Domain::Category.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: false
    )
  end

  let(:tvshow_category) do
    Domain::Category.new(
      name: 'TV Show',
      description: 'A thrilling TV show'
    )
  end

  context 'GET #index' do
    it 'should return empty list when there are no categories' do
      get :index

      expect(JSON.parse(response.body)).to(
        eq({
             'meta' => { 'current_page' => 1, 'page_size' => 10, 'total' => 0 },
             'data' => []
           })
      )
      expect(response.status).to(eq(200))
    end

    it 'should return list of categories' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(movie_category)
      repository.save(tvshow_category)

      get :index

      expected_data = {
        'meta' => { 'current_page' => 1, 'page_size' => 10, 'total' => 2 },
        'data' => [
          {
            'id' => movie_category.id,
            'name' => movie_category.name,
            'description' => movie_category.description,
            'is_active' => movie_category.is_active
          },
          {
            'id' => tvshow_category.id,
            'name' => tvshow_category.name,
            'description' => tvshow_category.description,
            'is_active' => tvshow_category.is_active
          }
        ]
      }

      expect(response.status).to(eq(200))
      expect(JSON.parse(response.body)).to(eq(expected_data))
    end
  end

  context 'GET #show' do
    it 'should return 400 when id is not valid' do
      get :show, params: { id: 'invalid_id' }

      expect(response.status).to(eq(400))
    end

    it 'should return category by id' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(movie_category)
      repository.save(tvshow_category)

      get :show, params: { id: movie_category.id }

      expected_data = {
        'data' => {
          'id' => movie_category.id,
          'name' => movie_category.name,
          'description' => movie_category.description,
          'is_active' => movie_category.is_active
        }
      }

      expect(JSON.parse(response.body)).to(eq(expected_data))
    end

    it 'should return 404 when category is not found' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(movie_category)
      repository.save(tvshow_category)

      get :show, params: { id: SecureRandom.uuid }

      expect(response.status).to(eq(404))
    end
  end

  context 'POST #create' do
    it 'returns 400 when category is invalid' do
      movie_category = {
        name: '',
        description: 'A very niiiiice movie'
      }

      post :create, params: movie_category

      expect(response.status).to(eq(400))
    end

    it 'returns 201 when category is valid' do
      movie_category = {
        name: 'Moooovie',
        description: 'A very niiiiice movie'
      }

      post :create, params: movie_category

      expect(response.status).to(eq(201))

      respository = Infra::Repository::ActiveRecordCategoryRepository.new
      parsed_body = JSON.parse(response.body)

      expect(parsed_body.fetch('data')).to(have_key('id'))

      response_id = parsed_body.dig('data', 'id')
      persisted_category = respository.get_by_id(id: response_id)
      category = Domain::Category.new(
        id: response_id,
        name: movie_category[:name],
        description: movie_category[:description],
        is_active: true
      )

      expect(category == persisted_category).to(be(true))
    end
  end

  context 'PUT #update' do
    it 'returns 400 when id is invalid' do
      put :update, params: { id: 'invalid_id', name: 'TV Show', is_active: false }

      expect(response.status).to(eq(400))
    end

    it 'returns 204 when category updated' do
      respository = Infra::Repository::ActiveRecordCategoryRepository.new
      respository.save(movie_category)

      put :update, params: { id: movie_category.id, name: 'TV Show', is_active: false }

      expect(response.status).to(eq(204))

      persisted_category = respository.get_by_id(id: movie_category.id)

      expect(persisted_category.name).to(eq('TV Show'))
      expect(persisted_category.description).to(eq(movie_category.description))
      expect(persisted_category.is_active).to(eq(false))
    end

    it 'returns 404 when category is not found' do
      put :update, params: { id: SecureRandom.uuid, name: 'TV Show', is_active: false }

      expect(response.status).to(eq(404))
    end
  end

  context 'DELETE #destroy' do
    it 'returns 400 when id is invalid' do
      delete :destroy, params: { id: 'invalid_id' }

      expect(response.status).to(eq(400))
    end

    it 'returns 204 when category deleted' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(movie_category)

      delete :destroy, params: { id: movie_category.id }

      expect(response.status).to(eq(204))
      expect do
        repository.get_by_id(id: movie_category.id)
      end.to(raise_error(Exceptions::CategoryNotFound,
                         "Category with id #{movie_category.id} not found"))
    end
  end
end
