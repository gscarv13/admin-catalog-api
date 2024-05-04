# frozen_string_literal: true

module Domain
  module Events
    class AudioVideoMediumUpdated < ApplicationStruct
      attribute :aggregate_id, Types::UUID
      attribute :file_path, Types::String
      attribute :media_type, Types::String
    end
  end
end
