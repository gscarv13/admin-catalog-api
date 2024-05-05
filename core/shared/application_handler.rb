# frozen_string_literal: true

class ApplicationHandler
  def initialize; end
  def handle(event: nil) = raise_not_implemented_error

  def raise_not_implemented_error
    raise StandardError, 'not implemented'
  end
end
