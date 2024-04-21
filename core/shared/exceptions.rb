# frozen_string_literal: true

module Exceptions
  class InvalidCategoryData < StandardError; end

  class CategoryNotFound < StandardError
    def initialize(id:)
      message = "Category with id #{id} not found"
      super(message)
    end
  end

  class InvalidGenreData < StandardError; end

  class GenreNotFound < StandardError
    def initialize(id:)
      message = "Genre with id #{id} not found"
      super(message)
    end
  end

  class RelatedCategoriesNotFound < StandardError
    def initialize(ids:)
      message = "Categories not found: #{ids.join(', ')}"
      super(message)
    end
  end
end