# frozen_string_literal: true

module Domain
  class Contract < Dry::Validation::Contract
    params do
      optional(:id).filled(Types::UUID)
      required(:title).filled(:string)
      required(:description).filled(:string)
      required(:launch_year).filled(:integer)
      required(:duration).filled(:decimal)
      required(:rating).filled(:string)
      required(:published).filled(:bool)

      # associations
      required(:categories).filled(:array).each(Types::UUID)
      required(:genres).filled(:array).each(Types::UUID)
      required(:cast_members).filled(:array).each(Types::UUID)

      # optionals
      optional(:banner).maybe(:string)
      optional(:thumbnail).maybe(:string)
      optional(:thumbnail_half).maybe(:string)
      optional(:trailer).maybe(:string)
      optional(:video).maybe(:string)
    end
  end

  class Video < ApplicationDomain # rubocop:disable Metrics/ClassLength
    attr_reader :id, :title, :description, :launch_year, :duration, :published, :rating, :categories, :genres,
                :cast_members, :banner, :thumbnail, :thumbnail_half, :trailer, :video

    RATING = {
      'er' => 'ER',
      'l' => 'L',
      'age_10' => 'AGE_10',
      'age_12' => 'AGE_12',
      'age_14' => 'AGE_14',
      'age_16' => 'AGE_16',
      'age_18' => 'AGE_18'
    }.freeze

    def initialize( # rubocop:disable Metrics/ParameterLists
      title:,
      description:,
      launch_year:,
      duration:,
      published:,
      rating:,
      id: nil,
      categories: [],
      genres: [],
      cast_members: [],
      banner: nil,
      thumbnail: nil,
      thumbnail_half: nil,
      trailer: nil,
      video: nil
      # opened: false
    )
      @id = id || SecureRandom.uuid
      @title = title
      @description = description
      @launch_year = launch_year
      @duration = duration
      @published = published
      @rating = RATING[rating.downcase]
      # @opened = opened

      @categories = categories
      @genres = genres
      @cast_members = cast_members

      @banner = banner # ImageMedia
      @thumbnail = thumbnail # ImageMedia
      @thumbnail_half = thumbnail_half # ImageMedia
      @trailer = trailer # AudioVideoMedia
      @video = video # AudioVideoMedia

      @notification = Notification.new

      validate
      super()
    end

    def update( # rubocop:disable Metrics/ParameterLists
      title: nil,
      description: nil,
      launch_year: nil,
      duration: nil,
      published: nil,
      rating: nil
    )
      @title = title
      @description = description
      @launch_year = launch_year
      @duration = duration
      @published = published
      @rating = RATING[rating]

      validate
    end

    def update_categories(categories)
      @categories << categories
      @categories.flatten!
      @categories.uniq!

      validate
    end

    def update_genres(genres)
      @genres << genres
      @genres.flatten!
      @genres.uniq!

      validate
    end

    def update_cast_members(cast_members)
      @cast_members << cast_members
      @cast_members.flatten!
      @cast_members.uniq!

      validate
    end

    def update_banner(banner)
      @banner = banner

      validate
    end

    def update_thumbnail(thumbnail)
      @thumbnail = thumbnail

      validate
    end

    def update_thumbnail_half(thumbnail_half)
      @thumbnail_half = thumbnail_half

      validate
    end

    def update_trailer(trailer)
      @trailer = trailer

      validate
    end

    def update_video_medium(video)
      @video = video
      validate

      event = Events::AudioVideoMediumUpdated.new(
        aggregate_id: @id,
        file_path: @video.raw_location,
        media_type: ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video]
      )

      dispatch(event)
    end

    def publish
      @published = true

      validate
    end

    def process(status:, encoded_location:)
      @video = if status == ValueObjects::AudioVideoMedium::MEDIA_STATUS[:completed]

                 Domain::ValueObjects::AudioVideoMedium.new(
                   name: @video.name,
                   raw_location: @video.raw_location,
                   medium_type: ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video],
                   encoded_location:,
                   status:
                 )
               else
                 Domain::ValueObjects::AudioVideoMedium.new(
                   name: @video.name,
                   raw_location: @video.raw_location,
                   medium_type: ValueObjects::AudioVideoMedium::MEDIA_TYPE[:video],
                   encoded_location: '',
                   status: ValueObjects::AudioVideoMedium::MEDIA_STATUS[:error]
                 )
               end

      validate
    end

    private

    def validate
      @notification.add_error('title must be present') if @title.nil? || @title.strip.empty?

      raise ArgumentError, @notification.messages if @notification.errors?
    end
  end
end
