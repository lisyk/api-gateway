# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbService::Partner, type: :model do
  describe 'database columns' do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:root_domain).of_type(:string) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:root_domain) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:root_domain) }
  end

  describe 'associations' do
    it { should have_many(:endpoints) }
    it { should have_many(:partner_fields) }
  end
end
