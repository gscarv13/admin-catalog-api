# frozen_string_literal: true

module Infra
  module Model
    class Category < ApplicationRecord
      attribute :id, :string
      attribute :name, :string
      attribute :description, :string
      attribute :is_active, :boolean
    end
  end
end
