# frozen_string_literal: true

module Domain
  class VideoRepository
    def save(_movie) = raise_not_implemented_error
    def get_by_id(_id) = raise_not_implemented_error
    def delete(_id) = raise_not_implemented_error
    def update(_movie) = raise_not_implemented_error
    def list(_input_dto) = raise_not_implemented_error

    private

    def raise_not_implemented_error
      raise StandardError, 'not implemented'
    end
  end
end
