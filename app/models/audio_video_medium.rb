# frozen_string_literal: true

class AudioVideoMedium < ApplicationRecord
  belongs_to :video

  enum status: {
    PENDING: 0,
    PROCESSING: 1,
    COMPLETED: 2,
    ERROR: 3
  }

  enum medium_type: {
    VIDEO: 0,
    TRAILER: 1
  }
end
