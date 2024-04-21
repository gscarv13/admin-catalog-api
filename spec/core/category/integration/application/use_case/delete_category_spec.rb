# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DeleteCategory integration test' do
  it 'deletes the category that corresponds to the given id' do
    movie_category = Domain::Category.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: true
    )

    tvshow_category = Domain::Category.new(
      name: 'TV Show',
      description: 'A thrilling TV show',
      is_active: true
    )

    repository = Infra::Repository::ActiveRecordCategoryRepository.new
    repository.save(movie_category)
    repository.save(tvshow_category)

    use_case = Application::UseCase::DeleteCategory.new(repository:)
    request_dto = Application::UseCase::DeleteCategoryRequest.new(id: movie_category.id)

    expect(repository.get_by_id(id: movie_category.id)).to_not(be_nil)

    response_dto = use_case.execute(request_dto)

    expect { repository.get_by_id(id: movie_category.id) }.to(raise_error(
                                                                Exceptions::CategoryNotFound,
                                                                "Category with id #{movie_category.id} not found"
                                                              ))

    expect(response_dto).to(be_nil)
  end
end
