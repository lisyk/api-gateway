# frozen_string_literal: true

module DbService
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
