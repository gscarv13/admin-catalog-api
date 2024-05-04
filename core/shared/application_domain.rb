# frozen_string_literal: true

class ApplicationDomain
  attr_reader :events

  def initialize(message_bus: nil)
    @events = []
    @message_bus = message_bus || Events::MessageBus.new
  end

  def ==(other)
    return false unless other.is_a?(self.class)

    @id == other.id
  end

  def dispatch(event)
    @events << event
    @message_bus.handle(event)
  end
end
