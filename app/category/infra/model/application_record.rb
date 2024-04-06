# frozen_string_literal: true

module Infra
  module Model
    class ApplicationRecord < ActiveRecord::Base
      self.abstract_class = true
    end
  end
end
