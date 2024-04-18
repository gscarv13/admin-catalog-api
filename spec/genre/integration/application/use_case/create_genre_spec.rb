# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Application::UseCase::CreateGenre integration specs' do
  let(:category) { Domain::Category.new(name: 'Movie') }
  let(:category2) { Domain::Category.new(name: 'Documentary') }

  let(:category_repository) do
    Infra::Repository::InMemoryCategoryRepository.new(categories: [category, category2])
  end

  let(:genre_repository) do
    Infra::Repository::InMemoryGenreRepository.new
  end

  it 'raises an error when category id does not exists' do
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
    request_dto = Application::UseCase::CreateGenreRequest.new(
      name: 'Action',
      categories: [category.id, category2.id]
    )

    use_case = Application::UseCase::CreateGenre.new(
      genre_repository:,
      category_repository:
    )

    response_dto = use_case.execute(request_dto)

    expect(response_dto)
      .to(eq(Application::UseCase::CreateGenreResponse.new(
               id: response_dto.id
             )))

    saved_genre = genre_repository.get_by_id(id: response_dto.id)

    expect(saved_genre.id).to(eq(response_dto.id))
    expect(saved_genre.name).to(eq('Action'))
    expect(saved_genre.categories).to(eq([category.id, category2.id]))
    expect(saved_genre.is_active).to(eq(true))
  end

  it 'saves genre when valid but categories is empty' do
    request_dto = Application::UseCase::CreateGenreRequest.new(
      name: 'Action',
      categories: []
    )

    use_case = Application::UseCase::CreateGenre.new(
      genre_repository:,
      category_repository:
    )

    response_dto = use_case.execute(request_dto)

    expect(response_dto)
      .to(eq(Application::UseCase::CreateGenreResponse.new(
               id: response_dto.id
             )))

    saved_genre = genre_repository.get_by_id(id: response_dto.id)

    expect(saved_genre.id).to(eq(response_dto.id))
    expect(saved_genre.name).to(eq('Action'))
    expect(saved_genre.categories).to(eq([]))
    expect(saved_genre.is_active).to(eq(true))
  end
end
