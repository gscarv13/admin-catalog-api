# frozen_string_literal: true

class CastMember < ApplicationRecord
  attribute :id, :string
  attribute :name, :string

  enum role_type: { actor: 0, director: 1 }
end
