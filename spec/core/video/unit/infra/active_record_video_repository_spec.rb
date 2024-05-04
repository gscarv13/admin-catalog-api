# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Infra::Repository::ActiveRecordVideoRepository do
  context '#save' do
    it 'should save a new video' do
      video_repository = Infra::Repository::ActiveRecordVideoRepository.new
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new

      category = Domain::Category.new(name: 'Documentary')
      genre = Domain::Genre.new(name: 'Horror')
      cast_member = Domain::CastMember.new(name: 'Tink', type: 'director')

      category_repository.save(category)
      genre_repository.save(genre)
      cast_member_repository.save(cast_member)

      video = Domain::Video.new(
        title: 'The Ring',
        description: 'Some description',
        launch_year: 2022,
        duration: BigDecimal('180'),
        published: false,
        rating: 'age_12',
        categories: [category.id],
        genres: [genre.id],
        cast_members: [cast_member.id]
      )

      expect(Video.count).to(eq(0))

      video_repository.save(video)

      expect(Video.count).to(eq(1))

      video_record = Video.find_by(id: video.id)

      expect(video_record.id).to(eq(video.id))
      expect(video_record.title).to(eq(video.title))
      expect(video_record.description).to(eq(video.description))
      expect(video_record.launch_year).to(eq(video.launch_year))
      expect(video_record.duration).to(eq(video.duration.to_s))
      expect(video_record.rating).to(eq(video.rating))
      expect(video_record.categories.pluck(:id)).to(eq([category.id]))
      expect(video_record.genres.pluck(:id)).to(eq([genre.id]))
      expect(video_record.cast_members.pluck(:id)).to(eq([cast_member.id]))
    end
  end

  context '#update' do
    it 'should update a video' do
      video_repository = Infra::Repository::ActiveRecordVideoRepository.new
      category_repository = Infra::Repository::ActiveRecordCategoryRepository.new
      genre_repository = Infra::Repository::ActiveRecordGenreRepository.new
      cast_member_repository = Infra::Repository::ActiveRecordCastMemberRepository.new

      category = Domain::Category.new(name: 'Documentary')
      genre = Domain::Genre.new(name: 'Horror')
      cast_member = Domain::CastMember.new(name: 'Tink', type: 'director')

      category_repository.save(category)
      genre_repository.save(genre)
      cast_member_repository.save(cast_member)

      video = Domain::Video.new(
        title: 'The Ring',
        description: 'Some description',
        launch_year: 2022,
        duration: BigDecimal('180'),
        published: false,
        rating: 'age_12',
        categories: [category.id],
        genres: [genre.id],
        cast_members: [cast_member.id]
      )

      expect(Video.count).to(eq(0))

      video_repository.save(video)

      expect(Video.count).to(eq(1))

      video.update(
        title: 'The Ring 2',
        description: 'Some description 2',
        launch_year: 2023,
        duration: BigDecimal('240'),
        published: true,
        rating: 'age_16'
      )

      video_repository.update(video)

      expect(Video.count).to(eq(1))

      video_record = Video.find(video.id)

      expect(video_record.id).to(eq(video.id))
      expect(video_record.title).to(eq('The Ring 2'))
      expect(video_record.description).to(eq('Some description 2'))
      expect(video_record.launch_year).to(eq(2023))
      expect(video_record.duration).to(eq('240.0'))
      expect(video_record.rating).to(eq('AGE_16'))
      expect(video_record.categories.pluck(:id)).to(eq([category.id]))
      expect(video_record.genres.pluck(:id)).to(eq([genre.id]))
      expect(video_record.cast_members.pluck(:id)).to(eq([cast_member.id]))
    end
  end
end
