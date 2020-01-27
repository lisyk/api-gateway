# frozen_string_literal: true

module DbService
  class Translation < ApplicationRecord
    validates :concept_name, presence: true
    validates :translation_value, presence: true
  end
end
