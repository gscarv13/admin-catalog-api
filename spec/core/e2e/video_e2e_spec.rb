# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'E2E spec of the whole system', type: :request do
  context 'from upload to message consumers' do
    let!(:video_repository) { Infra::Repository::ActiveRecordVideoRepository.new }
    let!(:genre_repository) { Infra::Repository::ActiveRecordGenreRepository.new }
    let!(:category_repository) { Infra::Repository::ActiveRecordCategoryRepository.new }
    let!(:cast_member_repository) { Infra::Repository::ActiveRecordCastMemberRepository.new }

    it 'allow create video and upload video media' do
      # create category
      post '/api/categories/', params: {
        name: 'Documentary',
        description: 'A factual film presenting real-life events, people, or issues, ' \
                     'often using interviews, footage, and narration.'
      }

      expect(response.status).to(eq(201))
      category_id = JSON.parse(response.body).dig('data', 'id')

      expect(Types::UUID[category_id]).to(be_instance_of(String))

      persisted_category = category_repository.get_by_id(id: category_id)

      expect(persisted_category.name).to(eq('Documentary'))
      expect(persisted_category.description).to(eq('A factual film presenting real-life events, people, or issues, ' \
                                                     'often using interviews, footage, and narration.'))
      expect(persisted_category.is_active).to(eq(true))

      # create genre
      post '/api/genres/', params: {
        name: 'Drama',
        categories: [category_id]
      }

      expect(response.status).to(eq(201))
      genre_id = JSON.parse(response.body).dig('data', 'id')

      expect(Types::UUID[genre_id]).to(be_instance_of(String))

      persisted_genre = genre_repository.get_by_id(id: genre_id)

      expect(persisted_genre.name).to(eq('Drama'))
      expect(persisted_genre.is_active).to(eq(true))
      expect(persisted_genre.categories).to(eq([category_id]))

      # create cast member
      post '/api/cast_members/', params: {
        name: 'Tink',
        type: 'director'
      }

      expect(response.status).to(eq(201))
      cast_member_id = JSON.parse(response.body).dig('data', 'id')

      expect(Types::UUID[cast_member_id]).to(be_instance_of(String))

      persisted_cast_member = cast_member_repository.get_by_id(id: cast_member_id)

      expect(persisted_cast_member.name).to(eq('Tink'))
      expect(persisted_cast_member.type).to(eq('DIRECTOR'))

      # Create one video
      post '/api/videos/', params: {
        "title": 'Spirited Away',
        "description": 'A young girl finds herself trapped in a mystical world, '\
                       'encountering strange creatures and facing extraordinary challenges',
        "launch_year": 2001,
        "duration": '125.0',
        "rating": 'l',
        "categories": [category_id],
        "genres": [genre_id],
        "cast_members": [cast_member_id]
      }

      expect(response.status).to(eq(201))

      video_id = JSON.parse(response.body).dig('data', 'id')
      expect(Types::UUID[video_id]).to(be_instance_of(String))

      persisted_video = video_repository.get_by_id(id: video_id)

      expect(persisted_video.id).to(eq(video_id))
      expect(persisted_video.title).to(eq('Spirited Away'))
      expect(persisted_video.description).to(eq('A young girl finds herself trapped in a mystical world, '\
                                                 'encountering strange creatures and facing extraordinary challenges'))
      expect(persisted_video.launch_year).to(eq(2001))
      expect(persisted_video.duration).to(eq('125.0'))
      expect(persisted_video.rating).to(eq('L'))
      expect(persisted_video.categories).to(eq([category_id]))
      expect(persisted_video.genres).to(eq([genre_id]))
      expect(persisted_video.cast_members).to(eq([cast_member_id]))

      # Upload video media
      put "/api/videos/#{video_id}", params: {
        video_file: fixture_file_upload('spec/fixtures/video_sample.mp4', 'video/mp4')
      }

      expect(response.status).to(eq(204))

      persisted_video = video_repository.get_by_id(id: video_id)
      video_medium = persisted_video.video

      expect(video_medium.name).to(eq('video_sample.mp4'))
      expect(video_medium.raw_location).to(eq("/videos/#{video_id}/video_sample.mp4"))
      expect(video_medium.encoded_location).to(eq(''))
      expect(video_medium.status).to(eq('PENDING'))
      expect(video_medium.medium_type).to(eq('VIDEO'))
    end
  end
end
