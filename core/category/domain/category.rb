# frozen_string_literal: true

module Domain
  class Category < ApplicationDomain
    attr_accessor :name, :description
    attr_reader :id, :is_active

    def initialize(name:, id: nil, description: nil, is_active: true)
      @id = id || SecureRandom.uuid
      @name = name
      @description = description
      @is_active = is_active
      @notification = Notification.new

      validate(name)
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

    private

    def validate(name)
      @notification.add_error('name must be present') if name.nil? || name.blank?
      @notification.add_error('name must be less than 256 characters') if name&.size&.> 255

      raise ArgumentError, @notification.messages if @notification.errors?
    end
  end
end
