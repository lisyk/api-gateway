# frozen_string_literal: true

module DbService
  class PetContract < ApplicationRecord
    validates :pet_id, :contract_app_id, presence: true
    validates :pet_id, :contract_app_id, uniqueness: true
  end
end
