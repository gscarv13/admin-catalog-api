# frozen_string_literal: true

require_relative '../../../../../src/core/category/application/use_cases/get_category'
require_relative '../../../../../src/core/category/domain/category'
require_relative '../../../../../src/core/category/application/category_repository_interface'
require_relative '../../../../../src/core/category/application/exceptions'

require 'securerandom'

RSpec.describe GetCategory do
  let(:uuid) { SecureRandom.uuid }

  let(:category) do
    Category.new(id: uuid, name: 'Moooovie', description: 'A very niiiiice movie')
  end

  it 'should create a new category with valid data' do
    repository_double = instance_double(CategoryRepositoryInterface, get_by_id: category)

    use_case = GetCategory.new(repository: repository_double)
    request_dto = GetCategoryRequest.new(id: uuid)
    response_dto = use_case.execute(request_dto)

    expect(response_dto.id).to(eq(uuid))
    expect(response_dto.name).to(eq('Moooovie'))
    expect(response_dto.description).to(eq('A very niiiiice movie'))
    expect(response_dto.is_active).to(eq(true))

    expect(repository_double).to(have_received(:get_by_id))
  end

  it 'should throw CategoryNotFound if category is missing' do
    repository_double = instance_double(CategoryRepositoryInterface, get_by_id: nil)

    use_case = GetCategory.new(repository: repository_double)
    request_dto = GetCategoryRequest.new(id: SecureRandom.uuid)

    expect { use_case.execute(request_dto) }
      .to(raise_error do |exception|
        expect(exception).to be_a CategoryNotFound
        expect(exception.message).to eq("Category with id #{request_dto.id} not found")
      end)
  end
end
