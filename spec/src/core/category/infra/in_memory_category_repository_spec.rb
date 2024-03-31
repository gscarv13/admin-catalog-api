# frozen_string_literal: true

require_relative '../../../../../src/core/category/infra/in_memory_category_repository'

RSpec.describe InMemoryCategoryRepository do
  context '#save' do
    it 'should save a new category' do
      repository = InMemoryCategoryRepository.new
      category = Category.new(name: 'Moooovie', description: 'A very niiiiice movie')

      repository.save(category)

      expect(repository.categories.size).to(eq(1))
      expect(repository.categories.first).to(eq(category))
    end
  end

  context '#get_by_id' do
    it 'returns a category with corresponding id' do
      category = Category.new(name: 'Moooovie', description: 'A very niiiiice movie')
      repository = InMemoryCategoryRepository.new(categories: [category])

      expect(repository.get_by_id(id: category.id)).to(eq(category))
    end
  end
end
