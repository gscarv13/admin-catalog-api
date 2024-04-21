# frozen_string_literal: true

RSpec.describe ' Application::UseCase::ListGenre integration specs' do
  let(:category) { Domain::Category.new(name: 'Movie') }
  let(:category2) { Domain::Category.new(name: 'Documentary') }

  it 'lists all genres with associated genres' do
    genre_repository = Infra::Repository::InMemoryGenreRepository.new
    _category_repository = Infra::Repository::InMemoryCategoryRepository.new(categories: [category, category2])

    genre = Domain::Genre.new(
      name: 'Horror',
      categories: [category.id, category2.id]
    )

    genre_repository.save(genre)

    use_case = Application::UseCase::ListGenre.new(genre_repository:)

    request_dto = Application::UseCase::ListGenreRequest.new
    response_dto = use_case.execute(request_dto)

    expect(response_dto).to(be_a(Application::UseCase::ListGenreResponse))
    expect(response_dto.data).to(eq([
                                      Application::UseCase::GenreOutput.new(
                                        id: genre.id,
                                        name: genre.name,
                                        is_active: genre.is_active,
                                        categories: genre.categories
                                      )
                                    ]))
  end

  it 'returns an empty array if there are no genres' do
    genre_repository = Infra::Repository::InMemoryGenreRepository.new

    use_case = Application::UseCase::ListGenre.new(genre_repository:)

    request_dto = Application::UseCase::ListGenreRequest.new
    response_dto = use_case.execute(request_dto)

    expect(response_dto).to(be_a(Application::UseCase::ListGenreResponse))
    expect(response_dto.data).to(eq([]))
  end
end
