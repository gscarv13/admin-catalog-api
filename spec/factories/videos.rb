# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    id { SecureRandom.uuid }
    title { Faker::Movie.title }
    description { Faker::Lorem.paragraph }
    launch_year { 2023 }
    duration { BigDecimal('120') }
    published { false }
    rating { Domain::Video::RATING.values.sample }
  end
end
