# frozen_string_literal: true

class CategoryRepositoryInterface
  def save(_category) = raise_not_implemented_error
  def get_by_id(_id) = raise_not_implemented_error

  private

  def raise_not_implemented_error
    raise StandardError, 'not implemented'
  end
end
