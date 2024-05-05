# frozen_string_literal: true

module Domain
  module ValueObjects
    class AudioVideoMedium
      attr_reader :name, :raw_location, :encoded_location, :status, :medium_type

      MEDIA_STATUS = {
        pending: 'PENDING',
        processing: 'PROCESSING',
        completed: 'COMPLETED',
        error: 'ERROR'
      }.freeze

      MEDIA_TYPE = {
        video: 'VIDEO',
        trailer: 'TRAILER'
      }.freeze

      def initialize(
        name:,
        raw_location:,
        encoded_location:,
        status:,
        medium_type:
      )
        @name = name
        @raw_location = raw_location
        @encoded_location = encoded_location
        @status = MEDIA_STATUS[status]
        @medium_type = MEDIA_TYPE[medium_type]
      end

      def ==(other)
        @name == other.name &&
          @raw_location == other.raw_location &&
          @encoded_location == other.encoded_location &&
          @status == other.status &&
          @medium_type == other.medium_type
      end
    end
  end
end
