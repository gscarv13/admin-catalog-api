# frozen_string_literal: true

module Application
  module DTO
    class UploadVideoInput < ApplicationStruct
      attribute :video_id, Types::String
      attribute :file_name, Types::String
      attribute :content, Types::String
      attribute :content_type, Types::String
    end
  end
end
