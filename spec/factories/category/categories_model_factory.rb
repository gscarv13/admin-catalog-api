# frozen_string_literal: true

FactoryBot.define do
  factory :category_model, class: 'Infra::Model::Category' do
    id { SecureRandom.uuid }
    name { Faker::Book.genre }
    description { Faker::Lorem.paragraphs(number: 2).join(' ').size }
    is_active { true }
  end
end
