# frozen_string_literal: true

require_relative '../application/category_repository_interface'

class InMemoryCategoryRepository < CategoryRepositoryInterface
  attr_reader :categories

  def initialize(categories: nil)
    @categories = categories || []
  end

  def save(category)
    @categories << category
  end

  def get_by_id(id:)
    @categories.find { |category| category.id == id }
  end

  def delete(id:)
    @categories.delete_if { |category| category.id == id }

    nil
  end

  def list
    # Given there is the possibility of returning an array that may be modified
    # we should use a copy to not alter the original array
    @categories.dup
  end

  def update(category)
    old_category = get_by_id(id: category.id)
    @categories.delete(old_category)
    @categories << category

    nil
  end
end
