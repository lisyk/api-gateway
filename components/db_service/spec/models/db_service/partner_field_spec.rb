require 'rails_helper'

RSpec.describe DbService::PartnerField, type: :model do
  describe 'database columns' do
    it { should have_db_column(:partner_id).of_type(:integer) }
    it { should have_db_column(:field_name).of_type(:string) }
    it { should have_db_column(:field_data_type).of_type(:string) }
  end

  describe 'validations' do
    it { should validate_presence_of(:field_name) }
  end

  describe 'associations' do
    it { should belong_to(:partner) }
  end
end
