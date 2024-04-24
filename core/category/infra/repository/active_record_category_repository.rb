# frozen_string_literal: true

module Infra
  module Repository
    class CategoryMapper
      def initialize(model: nil)
        @model = model || Category
      end

      def to_entity(model)
        Domain::Category.new(
          id: model.id,
          name: model.name,
          description: model.description,
          is_active: model.is_active
        )
      end

      def to_model(entity)
        @model.new(
          id: entity.id,
          name: entity.name,
          description: entity.description,
          is_active: entity.is_active
        )
      end
    end

    class ActiveRecordCategoryRepository < Domain::CategoryRepository
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

      def list
        categories = @model.all

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
