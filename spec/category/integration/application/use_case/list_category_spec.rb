# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ListCategory integration test' do
  it 'should return empty list when there are no categories' do
    repository = Infra::Repository::ActiveRecordCategoryRepository.new

    use_case = Application::UseCase::ListCategory.new(repository:)
    response_dto = use_case.execute(Application::UseCase::ListCategoryRequest.new)

    expect(response_dto).to(be_a(Application::UseCase::ListCategoryResponse))
    expect(response_dto.data).to(eq([]))
  end

  it 'should return list when there are categories' do
    movie_category = Domain::Category.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: false
    )

    tvshow_category = Domain::Category.new(
      name: 'TV Show',
      description: 'A thrilling TV show'
    )

    repository = Infra::Repository::ActiveRecordCategoryRepository.new
    repository.save(movie_category)
    repository.save(tvshow_category)

    use_case = Application::UseCase::ListCategory.new(repository:)
    response_dto = use_case.execute(Application::UseCase::ListCategoryRequest.new)

    expect(response_dto).to(be_a(Application::UseCase::ListCategoryResponse))
    expect(response_dto.data).to(eq([
                                      Application::UseCase::CategoryOutput.new(
                                        id: movie_category.id,
                                        name: 'Moooovie',
                                        description: 'A very niiiiice movie',
                                        is_active: false
                                      ),
                                      Application::UseCase::CategoryOutput.new(
                                        id: tvshow_category.id,
                                        name: 'TV Show',
                                        description: 'A thrilling TV show',
                                        is_active: true
                                      )
                                    ]))
  end
end
