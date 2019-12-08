# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbService::Translation, type: :model do
  describe 'database columns' do
    it { should have_db_column(:concept_name).of_type(:string) }
    it { should have_db_column(:partner_value).of_type(:string) }
    it { should have_db_column(:gateway_value).of_type(:string) }
  end

  describe 'validations' do
    it { should validate_presence_of(:concept_name) }
    it { should validate_presence_of(:gateway_value) }
  end
end
