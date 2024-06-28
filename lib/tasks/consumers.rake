# frozen_string_literal: true

require_relative '../../core/video/infra/consumer/video_converted_consumer'

namespace :consumers do
  desc 'Run consumers'
  task video_converted: :environment do
    Infra::Consumer::VideoConvertedConsumer.new.consume
    puts 'Running my task...'
  end
end
