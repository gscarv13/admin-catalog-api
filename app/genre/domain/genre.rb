# frozen_string_literal: true

module Domain
  class Genre
    attr_reader :id, :name, :categories, :is_active

    def initialize(name:, id: nil, categories: [], is_active: true)
      validate(name)

      @id = id || SecureRandom.uuid
      @name = name
      @categories = categories
      @is_active = is_active
    end

    def change_name(name)
      validate(name)

      @name = name
    end

    def activate
      @is_active = true
    end

    def deactivate
      @is_active = false
    end

    def add_category(category)
      @categories << category
    end

    def remove_category(category)
      @categories.delete(category)
    end

    def ==(other)
      return false unless other.is_a? Genre

      @id == other.id &&
        @name == other.name &&
        @categories == other.categories &&
        @is_active == other.is_active
    end

    def to_h
      {
        id: @id,
        name: @name,
        categories: @categories,
        is_active: @is_active
      }
    end

    def validate(name)
      raise ArgumentError, 'name must be present' if name.nil? || name.empty?
      raise ArgumentError, 'name must be less than 256 characters' if name.size > 255
    end
  end
end
