# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Web::Controllers::Api::CategoriesController, type: :controller do
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

      expect(JSON.parse(response.body)).to(eq({ 'data' => [] }))
      expect(response.status).to(eq(200))
    end

    it 'should return list of categories' do
      repository = Infra::Repository::ActiveRecordCategoryRepository.new
      repository.save(movie_category)
      repository.save(tvshow_category)

      get :index

      expected_data = {
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
end
