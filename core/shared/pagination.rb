# frozen_string_literal: true

module Pagination
  DEFAULT_PAGE_SIZE = 10

  def paginate(scope:, page: 1, page_size: DEFAULT_PAGE_SIZE)
    return scope if page.nil?

    scope.offset((page - 1) * page_size).limit(page_size)
  end

  def order_by(scope:, order_by:)
    return scope if order_by.nil?

    scope.order(order_by)
  end
end
