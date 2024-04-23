# frozen_string_literal: true

module Domain
  class CastMember
    class Contract < Dry::Validation::Contract
      params do
        optional(:id).maybe(Types::UUID)
        required(:name).filled(:string)
        required(:type).filled(:string)
      end

      rule(:type) do
        key.failure(text: 'must be either `actor` or `director`') if TYPE[values[:type]].nil?
      end
    end

    TYPE = {
      'actor' => 'actor',
      'director' => 'director'
    }.freeze

    attr_accessor :name, :type
    attr_reader :id

    def initialize(name:, type:, id: nil)
      validate(id:, name:, type:)

      @id = id || SecureRandom.uuid
      @name = name
      @type = TYPE[type]
    end

    def update(name:, type: @type)
      validate(name:, type:)

      @name = name
      @type = TYPE[type]
    end

    def ==(other)
      return false unless other.is_a? CastMember

      @id == other.id &&
        @name == other.name &&
        @type == other.type
    end

    def to_h
      {
        id: @id,
        name: @name,
        type: @type
      }
    end

    private

    def validate(**args)
      result = Contract.new.call(args, type: TYPE[args[:type]])

      return if result.success?

      message = result.errors.to_h.map { |k, v| "#{k} #{v}" }.join(', ')
      raise ArgumentError, message
    end
  end
end
