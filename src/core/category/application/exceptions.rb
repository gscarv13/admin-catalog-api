# frozen_string_literal: true

class InvalidCategoryData < StandardError; end

class CategoryNotFound < StandardError
  def initialize(id:)
    message = "Category with id #{id} not found"
    super(message)
  end
end
