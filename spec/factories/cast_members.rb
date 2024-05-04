# frozen_string_literal: true

FactoryBot.define do
  factory :cast_member do
    id { SecureRandom.uuid }
    name { Faker::JapaneseMedia::CowboyBebop.character }
    type { %w[ACTOR DIRECTOR].sample }
  end
end
