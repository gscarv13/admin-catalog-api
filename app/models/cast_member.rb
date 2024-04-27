# frozen_string_literal: true

class CastMember < ApplicationRecord
  attribute :id, :string
  attribute :name, :string

  # Due to ActiveRecord defaults, we can have a column named 'type'
  # it was renamed to 'role_type', and this alias allows us to keep using CastMember#type
  alias_attribute :type, :role_type

  enum role_type: { ACTOR: 0, DIRECTOR: 1 }
end
