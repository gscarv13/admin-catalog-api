# frozen_string_literal: true

class CastMember < ApplicationRecord
  attribute :id, :string
  attribute :name, :string

  enum role_type: { ACTOR: 0, DIRECTOR: 1 }
end
