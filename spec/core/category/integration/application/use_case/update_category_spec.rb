# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UpdateCategory integration test' do
  it 'should update a category name' do
    category = Domain::Category.new(
      name: 'Movie',
      description: 'A very nice movie',
      is_active: true
    )

    repository = Infra::Repository::ActiveRecordCategoryRepository.new
    repository.save(category)
    use_case = Application::UseCase::UpdateCategory.new(repository:)

    request_dto = Application::Dto::UpdateCategoryInput.new(
      id: category.id,
      name: 'TV Show',
      description: 'A very thrilling tv show'
    )

    use_case.execute(request_dto)

    updated_category = repository.get_by_id(id: category.id)
    expect(updated_category.name).to(eq('TV Show'))
    expect(updated_category.description).to(eq('A very thrilling tv show'))
  end
end
