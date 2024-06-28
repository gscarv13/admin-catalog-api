# frozen_string_literal: true

module Application
  module DTO
    class ProcessAudioVideoMediumInput < ApplicationStruct
      attribute :encoded_location, Types::String
      attribute :video_id, Types::UUID
      attribute :status, Types::String
      attribute :medium_type, Types::String
    end
  end
end
