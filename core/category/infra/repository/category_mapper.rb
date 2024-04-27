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

      def entity_to_hash(entity)
        {
          id: entity.id,
          name: entity.name,
          description: entity.description,
          is_active: entity.is_active
        }
      end
    end
  end
end
