# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::CategoriesController, type: :controller do
  context 'e2e specs' do
    it 'allow all CRUD operations' do # rubocop:disable Metrics/BlockLength
      # List all categories
      get :index

      expect(response.status).to(eq(200))
      expect(JSON.parse(response.body)).to(eq({ 'data' => [] }))

      category = {
        name: 'Moooovie',
        description: 'A very niiiiice movie'
      }

      # Create one category
      post :create, params: category

      parsed_body = JSON.parse(response.body)
      created_id = parsed_body.dig('data', 'id')

      expect(response.status).to(eq(201))
      expect(parsed_body)
        .to(eq({
                 'data' => {
                   'id' => created_id
                 }
               }))

      # Verify is previously created category exists
      get :index

      expect(response.status).to(eq(200))
      expect(JSON.parse(response.body))
        .to(eq({
                 'data' => [
                   {
                     'id' => created_id,
                     'name' => 'Moooovie',
                     'description' => 'A very niiiiice movie',
                     'is_active' => true
                   }
                 ]
               }))

      # Update category with new params
      put :update, params: {
        id: created_id,
        name: 'TV Show',
        description: 'A thrilling TV show',
        is_active: false
      }

      expect(response.status).to(eq(204))

      # Get the category by id
      get :show, params: { id: created_id }

      expect(response.status).to(eq(200))
      expect(JSON.parse(response.body))
        .to(eq({
                 'data' => {
                   'id' => created_id,
                   'name' => 'TV Show',
                   'description' => 'A thrilling TV show',
                   'is_active' => false
                 }
               }))

      # Delete category
      delete :destroy, params: { id: created_id }

      expect(response.status).to(eq(204))

      # Verify if category was deleted
      get :index
      expect(response.status).to(eq(200))
      expect(JSON.parse(response.body)).to(eq({ 'data' => [] }))
    end
  end
end
