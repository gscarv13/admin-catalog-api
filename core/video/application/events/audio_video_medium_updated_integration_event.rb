# frozen_string_literal: true

module Application
  module Events
    class AudioVideoMediumUpdatedIntegrationEvent < ApplicationStruct
      attribute :resource_id, Types::String # <uuid>.<MEDIA_TYPE>
      attribute :file_path, Types::String
    end
  end
end
