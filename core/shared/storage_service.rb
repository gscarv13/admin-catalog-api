# frozen_string_literal: true

class StorageService
  def initialize; end

  def store(file_path:, content:, content_type:)
    raise StandardError, 'not implemented'
  end
end
