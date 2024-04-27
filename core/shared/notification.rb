# frozen_string_literal: true

class Notification
  def initialize
    @messages = []
  end

  def errors?
    @messages.any?
  end

  def add_error(message)
    @messages << message
  end

  def messages
    @messages.join(', ')
  end
end
