# frozen_string_literal: true

module Domain
  class Category
    attr_accessor :name, :description
    attr_reader :id, :is_active

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

    def ==(other)
      return false unless other.is_a? Category

      @id == other.id &&
        @name == other.name &&
        @description == other.description &&
        @is_active == other.is_active
    end

    def to_h
      {
        id: @id,
        name: @name,
        description: @description,
        is_active: @is_active
      }
    end

    private

    def validate(name)
      raise ArgumentError, 'name must be present' if name.nil? || name.empty?
      raise ArgumentError, 'name must be less than 256 characters' if name.size > 255
    end
  end
end