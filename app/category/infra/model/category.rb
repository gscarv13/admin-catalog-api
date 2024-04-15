# frozen_string_literal: true

module Infra
  module Model
    class Category < ApplicationRecord
      has_and_belongs_to_many :genres

      attribute :id, :string
      attribute :name, :string
      attribute :description, :string
      attribute :is_active, :boolean
    end
  end
end
