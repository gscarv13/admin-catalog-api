# frozen_string_literal: true

require 'dry-types'

module Types
  include Dry.Types

  UUID = Types::String.constrained(
    format: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
  ).freeze
end
