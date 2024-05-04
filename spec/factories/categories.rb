# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    id { SecureRandom.uuid }
    description { Faker::Lorem.paragraph }
    name { ['Movie', 'TV Show', 'Documentary', 'Short', 'Anime', 'Talk-Show'].sample }

    # after(:create) do |category|
    #   3.times do
    #     category.genres << create(:genre)
    #   end
    # end
  end
end
