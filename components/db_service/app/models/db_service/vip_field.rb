# frozen_string_literal: true

module DbService
  class VipField < ApplicationRecord
    has_many :field_mappings
    validates :field_name, presence: true
  end
end
