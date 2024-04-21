# frozen_string_literal: true

RSpec.describe ' Application::UseCase::DeleteGenre integration specs' do
  it 'should delete genre from repository' do
    genre = Domain::Genre.new(name: 'Comedy')
    genre_repository = instance_double(Domain::GenreRepository, delete: nil, get_by_id: genre)
    use_case = Application::UseCase::DeleteGenre.new(genre_repository:)
    request_dto = Application::UseCase::DeleteGenreRequest.new(id: genre.id)
    use_case.execute(request_dto)

    expect(genre_repository).to(have_received(:delete).with(id: genre.id))
  end
end
