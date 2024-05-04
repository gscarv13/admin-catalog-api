# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Events::MessageBus do
  it 'calls correct handler with correct event' do
    dummy_event = instance_double(Events::ApplicationEvent)

    dummy_handler = instance_double(ApplicationHandler)

    allow(ApplicationHandler).to receive(:new).and_return(dummy_handler)
    allow(dummy_handler).to receive(:handle).with(events: dummy_event)

    message_bus = Events::MessageBus.new
    message_bus.handlers[dummy_event] = [ApplicationHandler]
    message_bus.handle(events: [dummy_event])

    expect(dummy_handler).to(have_received(:handle).with(events: dummy_event))
  end
end
