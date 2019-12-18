# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbService::Translation, type: :model do
  describe 'database columns' do
    it { should have_db_column(:concept_name).of_type(:string) }
    it { should have_db_column(:translation_value).of_type(:json) }
  end

  describe 'validations' do
    it { should validate_presence_of(:concept_name) }
    it { should validate_presence_of(:translation_value) }
  end
end
