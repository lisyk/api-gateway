# frozen_string_literal: true

module DbService
  class PetContract < ApplicationRecord
    validates :pet_uuid, :contract_app_id, presence: true
  end
end
