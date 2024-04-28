# frozen_string_literal: true

RSpec.describe Application::UseCase::CreateVideoWithoutMedia do
  let(:category) { Domain::Category.new(name: 'Moooovie', description: 'A very niiiiice movie') }
  let(:genre) { Domain::Genre.new(name: 'Horror') }
  let(:cast_member) { Domain::CastMember.new(name: 'Tink', type: 'director') }

  let(:video_repository) { instance_double(Domain::VideoRepository, save: nil) }
  let(:category_repository) { instance_double(Domain::CategoryRepository, list: [category]) }
  let(:genre_repository) { instance_double(Domain::GenreRepository, list: [genre]) }
  let(:cast_member_repository) { instance_double(Domain::CastMemberRepository, list: [cast_member]) }

  it 'should throw error if category id is not persisted' do
    invalid_category_id = SecureRandom.uuid
    input = Application::DTO::CreateVideoWithoutMediaInput.new(
      title: 'Movie',
      description: '',
      launch_year: 2023,
      duration: BigDecimal('120'),
      published: true,
      rating: 'l',
      categories: [invalid_category_id],
      genres: [genre.id],
      cast_members: [cast_member.id]
    )

    use_case = Application::UseCase::CreateVideoWithoutMedia.new(
      video_repository:,
      category_repository:,
      genre_repository:,
      cast_member_repository:
    )

    expect { use_case.execute(input) }.to(raise_error(
                                            Exceptions::RelatedAssociationsNotFound,
                                            "categories [#{invalid_category_id}] not found"
                                          ))
  end

  it 'should throw error if genre id is not persisted' do
    invalid_genre_id = SecureRandom.uuid
    input = Application::DTO::CreateVideoWithoutMediaInput.new(
      title: 'Movie',
      description: '',
      launch_year: 2023,
      duration: BigDecimal('120'),
      published: true,
      rating: 'l',
      categories: [category.id],
      genres: [invalid_genre_id],
      cast_members: [cast_member.id]
    )

    use_case = Application::UseCase::CreateVideoWithoutMedia.new(
      video_repository:,
      category_repository:,
      genre_repository:,
      cast_member_repository:
    )

    expect { use_case.execute(input) }.to(raise_error(
                                            Exceptions::RelatedAssociationsNotFound,
                                            "genres [#{invalid_genre_id}] not found"
                                          ))
  end

  it 'should throw error if cast member id is not persisted' do
    invalid_cast_member_id = SecureRandom.uuid
    input = Application::DTO::CreateVideoWithoutMediaInput.new(
      title: 'Movie',
      description: '',
      launch_year: 2023,
      duration: BigDecimal('120'),
      published: true,
      rating: 'l',
      categories: [category.id],
      genres: [genre.id],
      cast_members: [invalid_cast_member_id]
    )

    use_case = Application::UseCase::CreateVideoWithoutMedia.new(
      video_repository:,
      category_repository:,
      genre_repository:,
      cast_member_repository:
    )

    expect { use_case.execute(input) }.to(raise_error(
                                            Exceptions::RelatedAssociationsNotFound,
                                            "cast_members [#{invalid_cast_member_id}] not found"
                                          ))
  end

  it 'should accumulate association errors and throw error at once' do
    invalid_cast_member_id = SecureRandom.uuid
    invalid_genre_id = SecureRandom.uuid
    invalid_category_id = SecureRandom.uuid

    input = Application::DTO::CreateVideoWithoutMediaInput.new(
      title: 'Movie',
      description: '',
      launch_year: 2023,
      duration: BigDecimal('120'),
      published: true,
      rating: 'l',
      categories: [invalid_category_id],
      genres: [invalid_genre_id],
      cast_members: [invalid_cast_member_id]
    )

    use_case = Application::UseCase::CreateVideoWithoutMedia.new(
      video_repository:,
      category_repository:,
      genre_repository:,
      cast_member_repository:
    )

    expect { use_case.execute(input) }.to(raise_error(
                                            Exceptions::RelatedAssociationsNotFound,
                                            "categories [#{invalid_category_id}] not found, " \
                                            "genres [#{invalid_genre_id}] not found, " \
                                            "cast_members [#{invalid_cast_member_id}] not found" \
                                          ))
  end

  it 'should create a new video with valid data and return output DTO' do
    input = Application::DTO::CreateVideoWithoutMediaInput.new(
      title: 'Movie',
      description: '',
      launch_year: 2023,
      duration: BigDecimal('120'),
      published: true,
      rating: 'l',
      categories: [category.id],
      genres: [genre.id],
      cast_members: [cast_member.id]
    )

    use_case = Application::UseCase::CreateVideoWithoutMedia.new(
      video_repository:,
      category_repository:,
      genre_repository:,
      cast_member_repository:
    )

    output_dto = use_case.execute(input)
    expect(output_dto).to(eq(
                            Application::DTO::CreateVideoWithoutMediaOutput.new(id: output_dto.id)
                          ))
  end
end
