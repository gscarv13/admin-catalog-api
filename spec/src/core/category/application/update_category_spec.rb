# frozen_string_literal: true

RSpec.describe UpdateCategory do
  it 'should update a category name' do
    category = Category.new(
      name: 'Movie',
      description: 'A very nice movie',
      is_active: true
    )

    repository = instance_double(
      CategoryRepositoryInterface,
      get_by_id: category,
      update: nil
    )

    use_case = UpdateCategory.new(repository:)

    request_dto = UpdateCategoryRequest.new(
      id: category.id,
      name: 'TV Show'
    )

    use_case.execute(request_dto)

    expect(category.name).to(eq('TV Show'))
    expect(category.description).to(eq('A very nice movie'))
    expect(repository).to(have_received(:update).once)
  end

  it 'should update a category description' do
    category = Category.new(
      name: 'Movie',
      description: 'A very nice movie',
      is_active: true
    )

    repository = instance_double(
      CategoryRepositoryInterface,
      get_by_id: category,
      update: nil
    )

    use_case = UpdateCategory.new(repository:)

    request_dto = UpdateCategoryRequest.new(
      id: category.id,
      description: 'A not-so-nice movie'
    )

    use_case.execute(request_dto)

    expect(category.name).to(eq('Movie'))
    expect(category.description).to(eq('A not-so-nice movie'))

    expect(repository).to(have_received(:update).once)
  end

  it 'should activate a category' do
    category = Category.new(
      name: 'Movie',
      description: 'A very nice movie',
      is_active: false
    )

    repository = instance_double(
      CategoryRepositoryInterface,
      get_by_id: category,
      update: nil
    )

    use_case = UpdateCategory.new(repository:)

    request_dto = UpdateCategoryRequest.new(
      id: category.id,
      is_active: true
    )

    use_case.execute(request_dto)

    expect(category.is_active).to(eq(true))
    expect(repository).to(have_received(:update).once)
  end

  it 'should deactivate a category' do
    category = Category.new(
      name: 'Movie',
      description: 'A very nice movie',
      is_active: true
    )

    repository = instance_double(
      CategoryRepositoryInterface,
      get_by_id: category,
      update: nil
    )

    use_case = UpdateCategory.new(repository:)

    request_dto = UpdateCategoryRequest.new(
      id: category.id,
      is_active: false
    )

    use_case.execute(request_dto)

    expect(category.is_active).to(eq(false))
    expect(repository).to(have_received(:update).once)
  end
end
