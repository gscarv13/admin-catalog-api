# frozen_string_literal: true

class Genre < ApplicationRecord
  has_and_belongs_to_many :videos
  has_and_belongs_to_many :categories
end
