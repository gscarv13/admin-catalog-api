# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Create and persist a category' do
  it 'should create a new category with valid data' do
    uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/

    repository = Infra::Repository::ActiveRecordCategoryRepository.new
    use_case = Application::UseCase::CreateCategory.new(repository:)
    request_dto = Application::DTO::CreateCategoryInput.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: true
    )

    response_dto = use_case.execute(request_dto)
    persisted_category = repository.get_by_id(id: response_dto.id)

    expect(uuid_regex.match?(response_dto.id)).to(eq(true))

    expect(persisted_category.id).to(eq(response_dto.id))
    expect(persisted_category.name).to(eq('Moooovie'))
    expect(persisted_category.description).to(eq('A very niiiiice movie'))
    expect(persisted_category.is_active).to(eq(true))
  end

  it 'should not create a new category with invalid data' do
    repository = Infra::Repository::ActiveRecordCategoryRepository.new
    use_case = Application::UseCase::CreateCategory.new(repository:)
    request_dto = Application::DTO::CreateCategoryInput.new(
      name: 'a' * 256
    )

    expect { use_case.execute(request_dto) }
      .to(
        raise_error do |exception|
          expect(exception).to be_a(Exceptions::InvalidCategoryData)
          expect(exception.message).to eq('name must be less than 256 characters')

          expect(repository.list.size).to eq(0)
          expect(repository.list.first).to eq(nil)
        end
      )
  end
end
