# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbService::PetContract, type: :model do
  describe 'database columns' do
    it { should have_db_column(:pet_uuid).of_type(:uuid) }
    it { should have_db_column(:contract_app_id).of_type(:integer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:pet_uuid) }
    it { should validate_presence_of(:contract_app_id) }
  end
end
