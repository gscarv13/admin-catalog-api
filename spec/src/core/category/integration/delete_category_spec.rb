# frozen_string_literal: true

require_relative '../../../../../src/core/category/application/use_cases/get_category'

RSpec.describe 'DeleteCategory integration test' do
  it 'deletes the category that corresponds to the given id' do
    movie_category = Category.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: true
    )

    tvshow_category = Category.new(
      name: 'TV Show',
      description: 'A thrilling TV show',
      is_active: true
    )

    repository = InMemoryCategoryRepository.new(categories: [movie_category, tvshow_category])
    use_case = DeleteCategory.new(repository:)
    request_dto = DeleteCategoryRequest.new(id: movie_category.id)

    expect(repository.get_by_id(id: movie_category.id)).to_not(be_nil)

    response_dto = use_case.execute(request_dto)

    expect(repository.get_by_id(id: movie_category.id)).to(be_nil)
    expect(response_dto).to(be_nil)
  end
end
