# frozen_string_literal: true

require_relative '../../../../../src/core/category/application/use_cases/get_category'

RSpec.describe 'GetCategory integration test' do
  it 'returns a category with corresponding id' do
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
    use_case = GetCategory.new(repository:)
    request_dto = GetCategoryRequest.new(id: movie_category.id)

    response_dto = use_case.execute(request_dto)

    expect(response_dto)
      .to(eq(
            GetCategoryResponse.new(
              id: movie_category.id,
              name: 'Moooovie',
              description: 'A very niiiiice movie',
              is_active: true
            )
          ))
  end

  it 'raises error when category is not found' do
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
    use_case = GetCategory.new(repository:)
    not_found_id = SecureRandom.uuid
    request_dto = GetCategoryRequest.new(id: not_found_id)

    expect { use_case.execute(request_dto) }
      .to(
        raise_error do |exception|
          expect(exception).to be_a(CategoryNotFound)
          expect(exception.message).to eq("Category with id #{not_found_id} not found")
          expect(repository.categories.size).to eq(2)
        end
      )
  end
end
