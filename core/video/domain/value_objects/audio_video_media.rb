# frozen_string_literal: true

module Domain
  module ValueObjects
    class AudioVideoMedia
      attr_reader :name, :raw_location, :encoded_location, :status

      MEDIA_STATUS = {
        pending: 'PENDING',
        processing: 'PROCESSING',
        completed: 'COMPLETED',
        error: 'ERROR'
      }.freeze

      def initialize(
        name:,
        raw_location:,
        encoded_location:,
        status:
      )
        @name = name
        @raw_location = raw_location
        @encoded_location = encoded_location
        @status = MEDIA_STATUS[status]
      end

      def ==(other)
        @name == other.name &&
          @raw_location == other.raw_location &&
          @encoded_location == other.encoded_location &&
          @status == other.status
      end
    end
  end
end
