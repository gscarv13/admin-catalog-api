# frozen_string_literal: true

FactoryBot.define do
  factory :audio_video_medium do
    id { SecureRandom.uuid }
    association :video
    name { Faker::File.file_name(dir: '', directory_separator: nil, ext: 'mp4') }
    encoded_location { '' }
    raw_location { "/videos/#{video_id}/#{name}" }
    status { 'PENDING' }
  end
end
