# frozen_string_literal: true

FactoryBot.define do
  factory :genre do
    id { SecureRandom.uuid }
    name { %w[Action Comedy Drama Fantasy Horror Romance].sample }
    categories { [] }

    # after(:create) do |genre|
    #   genre.categories << 3.times { create(:category) }
    # end
  end
end
