# frozen_string_literal: true

require 'securerandom'

class Category
  attr_reader :id, :name, :description, :is_active

  def initialize(name:, id: nil, description: nil, is_active: true)
    validate(name)

    @id = id || SecureRandom.uuid
    @name = name
    @description = description
    @is_active = is_active
  end

  def update_category(name:, description:)
    validate(name)

    @name = name
    @description = description
  end

  def activate
    @is_active = true
  end

  def deactivate
    @is_active = false
  end

  def equal?(other)
    return false unless other.is_a? Category

    @id == other.id
  end

  private

  def validate(name)
    raise ArgumentError, 'name must be present' if name.nil? || name.empty?
    raise ArgumentError, 'name must be less than 256 characters' if name.size > 255
  end
end
