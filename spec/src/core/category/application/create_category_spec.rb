# frozen_string_literal: true

require 'securerandom'

require_relative '../../../../spec_helper'
require_relative '../../../../../src/core/category/application/create_category'
require_relative '../../../../../src/core/category/application/category_repository'
require_relative '../../../../../src/core/category/application/exceptions'

RSpec.describe CreateCategory do
  let(:repository_double) { instance_double('CategoryRepository', save: nil) }

  it 'should create a new category with valid data' do
    uuid = '123e4567-e89b-12d3-a456-426614174000'
    allow(SecureRandom).to receive(:uuid).and_return(uuid)

    use_case = CreateCategory.new(repository: repository_double)
    request_dto = CreateCategoryRequest.new(
      name: 'Moooovie',
      description: 'A very niiiiice movie',
      is_active: true
    )

    category_id = use_case.execute(request_dto)

    expect(category_id).to(eq(uuid))
    expect(repository_double).to(have_received(:save))
  end

  it 'should throw ArgumentError if name is missing' do
    use_case = CreateCategory.new(repository: repository_double)
    request_dto = CreateCategoryRequest.new(name: '')

    expect { use_case.execute(request_dto) }
      .to(raise_error(InvalidCategoryData, 'name must be present'))
  end
end
