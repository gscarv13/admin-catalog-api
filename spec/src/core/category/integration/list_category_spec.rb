# frozen_string_literal: true

RSpec.describe 'ListCategory integration test' do
  it 'should return empty list when there are no categories' do
    repository = InMemoryCategoryRepository.new

    use_case = ListCategory.new(repository:)
    response_dto = use_case.execute(ListCategoryRequest.new)

    expect(response_dto).to(be_a(ListCategoryResponse))
    expect(response_dto.data).to(eq([]))
  end

  it 'should return list when there are categories' do
    movie_category = Category.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: false
    )

    tvshow_category = Category.new(
      name: 'TV Show',
      description: 'A thrilling TV show'
    )

    repository = InMemoryCategoryRepository.new
    repository.save(movie_category)
    repository.save(tvshow_category)

    use_case = ListCategory.new(repository:)
    response_dto = use_case.execute(ListCategoryRequest.new)

    expect(response_dto).to(be_a(ListCategoryResponse))
    expect(response_dto.data).to(eq([
                                      CategoryOutput.new(
                                        id: movie_category.id,
                                        name: 'Moooovie',
                                        description: 'A very niiiiice movie',
                                        is_active: false
                                      ),
                                      CategoryOutput.new(
                                        id: tvshow_category.id,
                                        name: 'TV Show',
                                        description: 'A thrilling TV show',
                                        is_active: true
                                      )
                                    ]))
  end
end
