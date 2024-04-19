# frozen_string_literal: true

module Infra
  module Repository
    class ActiveRecordCategoryRepository < Domain::CategoryRepository
      attr_reader :categories

      def initialize(model: nil)
        @model = model || Category
      end

      def save(category)
        @model.create!(category.to_h)

        nil
      end

      def get_by_id(id:)
        result = @model.find_by(id:)

        raise Exceptions::CategoryNotFound.new(id:) if result.nil?

        Domain::Category.new(
          id: result.id,
          name: result.name,
          description: result.description,
          is_active: result.is_active
        )
      end

      def delete(id:)
        active_record_object = @model.find_by(id:)
        active_record_object&.destroy

        nil
      end

      def list
        categories = @model.all

        categories.map do |category|
          Domain::Category.new(
            id: category.id,
            name: category.name,
            description: category.description,
            is_active: category.is_active
          )
        end
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
