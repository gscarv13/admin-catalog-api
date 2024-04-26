# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::CreateCategory do
  let(:repository_double) { instance_double(Domain::CategoryRepository, save: nil) }

  it 'should create a new category with valid data' do
    uuid = '123e4567-e89b-12d3-a456-426614174000'
    allow(SecureRandom).to receive(:uuid).and_return(uuid)

    use_case = Application::UseCase::CreateCategory.new(repository: repository_double)
    request_dto = Application::Dto::CreateCategoryInput.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: true
    )

    response_dto = use_case.execute(request_dto)

    expect(response_dto.id).to(eq(uuid))
    expect(repository_double).to(have_received(:save))
  end

  it 'should throw ArgumentError if name is missing' do
    use_case = Application::UseCase::CreateCategory.new(repository: repository_double)
    request_dto = Application::Dto::CreateCategoryInput.new(name: '')

    expect { use_case.execute(request_dto) }
      .to(raise_error(Exceptions::InvalidCategoryData, 'name must be present'))
  end
end
