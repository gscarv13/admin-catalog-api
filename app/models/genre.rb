# frozen_string_literal: true

class Genre < ActiveRecord::Base
  has_and_belongs_to_many :categories

  attribute :id, :string
  attribute :name, :string
  attribute :is_active, :boolean
end
