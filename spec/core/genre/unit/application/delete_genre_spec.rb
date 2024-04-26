# frozen_string_literal: true

RSpec.describe Application::UseCase::DeleteGenre do
  it 'should delete genre from repository' do
    genre = Domain::Genre.new(name: 'Comedy')
    genre_repository = instance_double(Domain::GenreRepository, delete: nil, get_by_id: genre)
    use_case = Application::UseCase::DeleteGenre.new(genre_repository:)
    request_dto = Application::Dto::DeleteGenreInput.new(id: genre.id)
    use_case.execute(request_dto)

    expect(genre_repository).to(have_received(:delete).with(id: genre.id))
  end

  it 'raises an error when genre is not found' do
    not_found_id = SecureRandom.uuid
    genre_repository = instance_double(Domain::GenreRepository, delete: nil, get_by_id: nil)
    use_case = Application::UseCase::DeleteGenre.new(genre_repository:)
    request_dto = Application::Dto::DeleteGenreInput.new(id: not_found_id)

    expect { use_case.execute(request_dto) }.to(raise_error(
                                                  Exceptions::GenreNotFound,
                                                  "Genre with id #{not_found_id} not found"
                                                ))
  end
end
