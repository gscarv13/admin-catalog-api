# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordCategoryRepository < Domain::CategoryRepository
      include Pagination
      attr_reader :categories

      def initialize(model: nil)
        @model = model || Category
        @mapper = CategoryMapper.new(model: @model)
      end

      def save(category)
        category_model = @mapper.to_model(category)
        category_model.save!

        nil
      end

      def get_by_id(id:)
        result = @model.find_by(id:)
        raise Exceptions::CategoryNotFound.new(id:) if result.nil?

        @mapper.to_entity(result)
      end

      def delete(id:)
        active_record_object = @model.find_by(id:)
        active_record_object&.destroy

        nil
      end

      def list(request_dto = nil)
        categories = paginate(scope: @model.all, page: request_dto&.page, page_size: request_dto&.page_size)
        categories = order_by(scope: categories, order_by: request_dto&.order_by)

        categories.map { |category| @mapper.to_entity(category) }
      end

      def update(category)
        current_category = @model.find_by(id: category.id)
        current_category&.assign_attributes(category.to_h)
        current_category&.save!

        nil
      end
    end
  end
end
