# frozen_string_literal: true

module DbService
  class AgeGroupTranslation < ApplicationRecord
    validates :species, presence: true
    validates :age_group, presence: true
  end
end
