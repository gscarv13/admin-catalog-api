# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::ListGenre do
  let(:movie_category) { Domain::Category.new(name: 'Movie') }
  let(:tvshow_category) { Domain::Category.new(name: 'TV Show') }

  it 'should return empty list when there are no genres' do
    genre_repository = instance_double(
      Domain::GenreRepository,
      list: []
    )

    use_case = Application::UseCase::ListGenre.new(genre_repository:)
    response_dto = use_case.execute(Application::UseCase::ListGenreRequest.new)

    expect(response_dto).to(be_a(Application::UseCase::ListGenreResponse))
    expect(response_dto.data).to(eq([]))
  end

  it 'should return list when there are categories' do
    genre = Domain::Genre.new(
      name: 'Comedy',
      categories: [movie_category.id, tvshow_category.id]
    )

    genre_repository = instance_double(Domain::GenreRepository, list: [genre])

    use_case = Application::UseCase::ListGenre.new(genre_repository:)
    response_dto = use_case.execute(Application::UseCase::ListGenreRequest.new)

    expect(response_dto).to(be_a(Application::UseCase::ListGenreResponse))
    expect(response_dto.data).to(eq([
                                      Application::UseCase::GenreOutput.new(
                                        id: genre.id,
                                        name: 'Comedy',
                                        is_active: true,
                                        categories: [movie_category.id, tvshow_category.id]
                                      )
                                    ]))
  end
end
