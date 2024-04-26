# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Application::UseCase::DeleteCategory do
  let(:category) { Domain::Category.new(name: 'Moooovie', description: 'A very niiiiice movie') }

  it 'deletes a category with corresponding id and return nil' do
    repository_double = instance_double(Domain::CategoryRepository, delete: nil, get_by_id: category)
    use_case = Application::UseCase::DeleteCategory.new(repository: repository_double)
    request_dto = Application::Dto::DeleteCategoryInput.new(id: category.id)

    expect(use_case.execute(request_dto)).to(be_nil)
    expect(repository_double).to(have_received(:delete).with(id: category.id))
  end

  it 'raises error when category is not found' do
    repository_double = instance_double(Domain::CategoryRepository, delete: nil, get_by_id: nil)
    use_case = Application::UseCase::DeleteCategory.new(repository: repository_double)
    request_dto = Application::Dto::DeleteCategoryInput.new(id: category.id)

    expect { use_case.execute(request_dto) }
      .to(raise_error do |exception|
            expect(exception).to be_a(Exceptions::CategoryNotFound)
            expect(exception.message).to eq("Category with id #{category.id} not found")
            expect(repository_double).to_not(have_received(:delete))
          end)
  end
end
