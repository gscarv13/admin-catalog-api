# frozen_string_literal: true

class InMemoryCategoryRepository < CategoryRepository
  attr_reader :categories

  def initialize(categories = nil)
    @categories = categories || []
  end

  def save(category)
    @categories << category
  end
end
