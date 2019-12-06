# frozen_string_literal: true

module DbService
  class Translation < ApplicationRecord
    validates :concept_name, presence: true
    validates :gateway_value, presence: true
  end
end
