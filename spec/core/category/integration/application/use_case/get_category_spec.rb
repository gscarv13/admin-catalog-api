# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'GetCategory integration test' do
  it 'returns a category with corresponding id' do
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

    use_case = Application::UseCase::GetCategory.new(repository:)
    request_dto = Application::DTO::GetCategoryInput.new(id: movie_category.id)

    response_dto = use_case.execute(request_dto)

    expect(response_dto)
      .to(eq(
            Application::DTO::GetCategoryOutput.new(
              id: movie_category.id,
              name: 'Moooovie',
              description: 'A very niiiiice movie',
              is_active: true
            )
          ))
  end

  it 'raises error when category is not found' do
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

    use_case = Application::UseCase::GetCategory.new(repository:)
    not_found_id = SecureRandom.uuid
    request_dto = Application::DTO::GetCategoryInput.new(id: not_found_id)

    expect { use_case.execute(request_dto) }
      .to(
        raise_error do |exception|
          expect(exception).to be_a(Exceptions::CategoryNotFound)
          expect(exception.message).to eq("Category with id #{not_found_id} not found")
          expect(repository.list.size).to eq(2)
        end
      )
  end
end
