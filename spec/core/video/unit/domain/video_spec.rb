# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Domain::Video do
  let(:video) do
    Domain::Video.new(
      title: 'Movie',
      description: '',
      launch_year: 2023,
      duration: BigDecimal('120'),
      published: true,
      rating: 'l'
    )
  end

  it 'should raise error if title is nil' do
    expect do
      Domain::Video.new(
        title: nil,
        description: '',
        launch_year: 2023,
        duration: BigDecimal('120'),
        published: true,
        rating: 'l'
      )
    end
      .to(raise_error(ArgumentError, 'title must be present'))
  end

  context '#update' do
    it 'updates video title, description, launch_year, duration, published and rating' do
      video.update(
        title: 'TV Show',
        description: 'Some description',
        launch_year: 2022,
        duration: BigDecimal('180'),
        published: false,
        rating: 'age_12'
      )

      expect(video.title).to(eq('TV Show'))
      expect(video.description).to(eq('Some description'))
      expect(video.launch_year).to(eq(2022))
      expect(video.duration).to(eq(BigDecimal('180')))
      expect(video.published).to(eq(false))
      expect(video.rating).to(eq('AGE_12'))
    end

    it 'should raise error if title is updated to nil' do
      expect { video.update(title: nil) }.to(raise_error(ArgumentError, 'title must be present'))
    end

    it 'should raise error if title is updated to empty string' do
      expect { video.update(title: '') }.to(raise_error(ArgumentError, 'title must be present'))
    end

    it 'should raise error if title is updated to string without any character' do
      expect { video.update(title: '            ') }.to(raise_error(ArgumentError, 'title must be present'))
    end
  end

  context '#update_categories' do
    it 'updates video categories' do
      expect(video.categories).to(eq([]))

      id1 = SecureRandom.uuid
      id2 = SecureRandom.uuid

      video.update_categories([id1, id2])

      expect(video.categories.size).to(eq(2))
      expect(video.categories.any?(id1)).to(eq(true))
      expect(video.categories.any?(id2)).to(eq(true))

      id3 = SecureRandom.uuid
      video.update_categories(id3)

      expect(video.categories.size).to(eq(3))
      expect(video.categories.any?(id3)).to(eq(true))
    end
  end

  context '#update_genres' do
    it 'updates video genres' do
      expect(video.genres).to(eq([]))

      id1 = SecureRandom.uuid
      id2 = SecureRandom.uuid

      video.update_genres([id1, id2])

      expect(video.genres.size).to(eq(2))
      expect(video.genres.any?(id1)).to(eq(true))
      expect(video.genres.any?(id2)).to(eq(true))

      id3 = SecureRandom.uuid
      video.update_genres(id3)

      expect(video.genres.size).to(eq(3))
      expect(video.genres.any?(id3)).to(eq(true))
    end
  end

  context '#update_cast_members' do
    it 'updates video cast_members' do
      expect(video.cast_members).to(eq([]))

      id1 = SecureRandom.uuid
      id2 = SecureRandom.uuid

      video.update_cast_members([id1, id2])

      expect(video.cast_members.size).to(eq(2))
      expect(video.cast_members.any?(id1)).to(eq(true))
      expect(video.cast_members.any?(id2)).to(eq(true))

      id3 = SecureRandom.uuid
      video.update_cast_members(id3)

      expect(video.cast_members.size).to(eq(3))
      expect(video.cast_members.any?(id3)).to(eq(true))
    end
  end

  # update_banner
  # update_thumbnail
  # update_thumbnail_half
  # update_trailer

  context '#update_video_medium' do
    it 'should update video and dispatch event' do
      audio_video_medium = Domain::ValueObjects::AudioVideoMedium.new(
        name: 'video.mp4',
        raw_location: '/videos/123/video.mp4',
        encoded_location: nil,
        status: :pending,
        medium_type: :video
      )

      video.update_video_medium(audio_video_medium)

      expect(video.video).to(eq(audio_video_medium))
      expect(video.events).to(eq([Domain::Events::AudioVideoMediumUpdated.new(
        aggregate_id: video.id,
        file_path: '/videos/123/video.mp4',
        media_type: Domain::ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video]
      )]))
    end
  end
end
