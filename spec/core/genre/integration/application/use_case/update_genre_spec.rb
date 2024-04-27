# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Application::UseCase::UpdateGenre integration specs' do
  it 'when genre does not exist should raise error' do
    genre_repository = Infra::Repository::InMemoryGenreRepository.new
    category_repository = Infra::Repository::InMemoryCategoryRepository.new

    use_case = Application::UseCase::UpdateGenre.new(genre_repository:, category_repository:)
    request_dto = Application::DTO::UpdateGenreInput.new(
      id: SecureRandom.uuid,
      name: 'Horror',
      categories: [],
      is_active: true
    )

    expect { use_case.execute(request_dto) }.to(
      raise_error(Exceptions::GenreNotFound)
    )
  end

  it 'when genre request has invalid params should raise invalid genre error' do
    genre = Domain::Genre.new(name: 'Comedy')
    genre_repository = Infra::Repository::InMemoryGenreRepository.new(genres: [genre])
    category_repository = Infra::Repository::InMemoryCategoryRepository.new

    use_case = Application::UseCase::UpdateGenre.new(genre_repository:, category_repository:)
    request_dto = Application::DTO::UpdateGenreInput.new(
      id: genre.id,
      name: '',
      categories: [],
      is_active: true
    )

    expect { use_case.execute(request_dto) }.to(
      raise_error(Exceptions::InvalidGenreData, 'name must be present')
    )
  end

  it 'when provided category id does not exist should raise related category error' do
    genre = Domain::Genre.new(name: 'Comedy')
    genre_repository = Infra::Repository::InMemoryGenreRepository.new(genres: [genre])
    category_repository = Infra::Repository::InMemoryCategoryRepository.new

    unkown_id = SecureRandom.uuid
    use_case = Application::UseCase::UpdateGenre.new(genre_repository:, category_repository:)
    request_dto = Application::DTO::UpdateGenreInput.new(
      id: genre.id,
      name: 'Western',
      categories: [unkown_id],
      is_active: true
    )

    expect { use_case.execute(request_dto) }.to(
      raise_error(Exceptions::RelatedCategoriesNotFound,
                  "Categories not found: #{unkown_id}")
    )
  end

  it 'should update genre from repository' do
    category = Domain::Category.new(name: 'Movie')
    category_repository = Infra::Repository::InMemoryCategoryRepository.new(categories: [category])

    genre = Domain::Genre.new(name: 'Comedy', is_active: false)
    genre_repository = Infra::Repository::InMemoryGenreRepository.new(genres: [genre])

    expect(genre_repository.get_by_id(id: genre.id)).to(eq(genre))

    use_case = Application::UseCase::UpdateGenre.new(
      genre_repository:,
      category_repository:
    )

    request_dto = Application::DTO::UpdateGenreInput.new(
      id: genre.id,
      name: 'Horror',
      categories: [category.id],
      is_active: true
    )

    use_case.execute(request_dto)

    updated_genre = genre_repository.get_by_id(id: genre.id)
    expect(updated_genre.id).to(eq(genre.id))
    expect(updated_genre.name).to(eq('Horror'))
    expect(updated_genre.is_active).to(eq(true))
    expect(updated_genre.categories).to(eq([category.id]))
  end
end
