# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    id { SecureRandom.uuid }
    title { Faker::Movie.title }
    description { Faker::Lorem.paragraph }
    launch_year { 2023 }
    duration { BigDecimal('120') }
    published { false }
    rating { %w[ER L AGE_10 AGE_12 AGE_14 AGE_16 AGE_18].sample }
  end
end
