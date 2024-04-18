# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::CreateGenre do
  let(:category) { Domain::Category.new(name: 'Movie') }
  let(:category2) { Domain::Category.new(name: 'Documentary') }

  let(:category_repository) do
    instance_double(Domain::CategoryRepository, list: [category, category2])
  end

  it 'raises an error when category id does not exists' do
    genre_repository = instance_double(Domain::GenreRepository, save: nil)

    not_found_id = SecureRandom.uuid
    request_dto = Application::UseCase::CreateGenreRequest.new(
      name: 'Horror',
      categories: [not_found_id]
    )

    use_case = Application::UseCase::CreateGenre.new(
      genre_repository:,
      category_repository:
    )

    expect { use_case.execute(request_dto) }.to(raise_error(
                                                  Exceptions::RelatedCategoriesNotFound,
                                                  "Categories not found: #{not_found_id}"
                                                ))
  end

  it 'raises an error when genre is invalid' do
    genre_repository = instance_double(Domain::GenreRepository, save: nil)

    request_dto = Application::UseCase::CreateGenreRequest.new(
      name: '',
      categories: [category.id, category2.id]
    )

    use_case = Application::UseCase::CreateGenre.new(
      genre_repository:,
      category_repository:
    )

    expect { use_case.execute(request_dto) }.to(raise_error(
                                                  Exceptions::InvalidGenreData,
                                                  'name must be present'
                                                ))
  end

  it 'saves when genre is valid' do
    genre_repository = instance_double(Domain::GenreRepository, save: nil)

    request_dto = Application::UseCase::CreateGenreRequest.new(
      name: 'Action',
      categories: [category.id, category2.id]
    )

    use_case = Application::UseCase::CreateGenre.new(
      genre_repository:,
      category_repository:
    )

    response_dto = use_case.execute(request_dto)

    expect(genre_repository).to(have_received(:save).with(
                                  Domain::Genre.new(
                                    id: response_dto.id,
                                    name: 'Action',
                                    is_active: true,
                                    categories: [category.id, category2.id]
                                  )
                                ))

    expect(response_dto)
      .to(eq(Application::UseCase::CreateGenreResponse.new(
               id: response_dto.id
             )))
  end
end
