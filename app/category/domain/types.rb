# frozen_string_literal: true

module Domain
  module Types
    include Dry.Types

    UUID = Types::String.constrained(
      format: /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i
    )
  end
end
