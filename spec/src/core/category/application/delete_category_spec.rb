# frozen_string_literal: true

RSpec.describe 'DeleteCategory' do
  let(:category) { Category.new(name: 'Moooovie', description: 'A very niiiiice movie') }

  it 'deletes a category with corresponding id and return nil' do
    repository_double = instance_double(CategoryRepositoryInterface, delete: nil, get_by_id: category)
    use_case = DeleteCategory.new(repository: repository_double)
    request_dto = DeleteCategoryRequest.new(id: category.id)

    expect(use_case.execute(request_dto)).to(be_nil)
    expect(repository_double).to(have_received(:delete).with(id: category.id))
  end

  it 'raises error when category is not found' do
    repository_double = instance_double(CategoryRepositoryInterface, delete: nil, get_by_id: nil)
    use_case = DeleteCategory.new(repository: repository_double)
    request_dto = DeleteCategoryRequest.new(id: category.id)

    expect { use_case.execute(request_dto) }
      .to(raise_error do |exception|
            expect(exception).to be_a(CategoryNotFound)
            expect(exception.message).to eq("Category with id #{category.id} not found")
            expect(repository_double).to_not(have_received(:delete))
          end)
  end
end
