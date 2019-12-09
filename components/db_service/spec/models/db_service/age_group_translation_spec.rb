# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbService::AgeGroupTranslation, type: :model do
  describe 'database columns' do
    it { should have_db_column(:species).of_type(:integer) }
    it { should have_db_column(:age_group).of_type(:integer) }
    it { should have_db_column(:minimum_age).of_type(:integer) }
  end

  describe 'validations' do
    it { should validate_presence_of(:species) }
    it { should validate_presence_of(:age_group) }
  end
end
