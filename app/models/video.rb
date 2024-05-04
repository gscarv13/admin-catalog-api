# frozen_string_literal: true

class Video < ApplicationRecord
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :genres
  has_and_belongs_to_many :cast_members

  has_one :audio_video_medium

  enum rating: {
    ER: 0,
    L: 1,
    AGE_10: 2,
    AGE_12: 3,
    AGE_14: 4,
    AGE_16: 5,
    AGE_18: 6
  }

  validates :title, presence: true
end
