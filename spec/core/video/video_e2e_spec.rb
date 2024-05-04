# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::VideosController, type: :controller do
  context 'e2e specs' do
    it 'allow create video and upload video media' do
      # setup
      category = create(:category)
      genre = create(:genre)
      cast_member = create(:cast_member)

      # Create one video
      post :create, params: {
        "title": 'Quod voluptas est',
        "description": 'Praesentium nostrum perspiciatis. Culpa quod a. Occaecati consequatur ad.',
        "launch_year": 2023,
        "duration": '120.0',
        "rating": 'l',
        "categories": [category.id],
        "genres": [genre.id],
        "cast_members": [cast_member.id]
      }

      parsed_body = JSON.parse(response.body)

      expect(response.status).to(eq(201))
      expect(parsed_body).to(
        include(
          'data' => include(
            'id' => anything
          )
        )
      )

      id = parsed_body.dig('data', 'id')
      expect(Types::UUID[id]).to(be_instance_of(String))

      video_path = Rails.root.join('spec/fixtures/video_sample.mp4')

      # Upload video media
      post :update, params: {
        id:,
        video_file: fixture_file_upload(video_path, 'video/mp4')
      }

      expect(response.status).to(eq(204))
    end
  end
end
