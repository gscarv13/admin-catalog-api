# frozen_string_literal: true

class Category < ApplicationRecord
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :videos
end
