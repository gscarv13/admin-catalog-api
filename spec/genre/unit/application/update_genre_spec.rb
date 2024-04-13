# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::UpdateGenre do
  it 'when genre does not exist should raise error' do
    genre_repository = instance_double(Domain::GenreRepository, get_by_id: nil)
    category_repository = instance_double(Domain::CategoryRepository, get_by_id: nil)

    use_case = Application::UseCase::UpdateGenre.new(genre_repository:, category_repository:)
    request_dto = Application::UseCase::UpdateGenreRequest.new(
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
    genre_repository = instance_double(Domain::GenreRepository, get_by_id: genre)
    category_repository = instance_double(Domain::CategoryRepository, get_by_id: nil)

    use_case = Application::UseCase::UpdateGenre.new(genre_repository:, category_repository:)
    request_dto = Application::UseCase::UpdateGenreRequest.new(
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
    genre_repository = instance_double(Domain::GenreRepository, get_by_id: genre)
    category_repository = instance_double(Domain::CategoryRepository, get_by_id: nil)

    unkown_id = SecureRandom.uuid
    use_case = Application::UseCase::UpdateGenre.new(genre_repository:, category_repository:)
    request_dto = Application::UseCase::UpdateGenreRequest.new(
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
    category_repository = instance_double(Domain::CategoryRepository, get_by_id: category)

    genre = Domain::Genre.new(name: 'Comedy', is_active: false)
    genre_repository = instance_double(Domain::GenreRepository, get_by_id: genre, update: nil)

    expect(genre_repository.get_by_id(id: genre.id)).to(eq(genre))

    use_case = Application::UseCase::UpdateGenre.new(
      genre_repository:,
      category_repository:
    )

    request_dto = Application::UseCase::UpdateGenreRequest.new(
      id: genre.id,
      name: 'Horror',
      categories: [category.id],
      is_active: true
    )

    use_case.execute(request_dto)

    expect(genre_repository).to(
      have_received(:update).with(
        Domain::Genre.new(
          id: genre.id,
          name: 'Horror',
          is_active: true,
          categories: [category.id]
        )
      )
    )
  end
end
