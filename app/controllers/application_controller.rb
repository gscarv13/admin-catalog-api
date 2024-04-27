# frozen_string_literal: true

class ApplicationController < ActionController::API
  def default_pagination_params
    params.permit(:page, :page_size, :order_by)
  end
end
