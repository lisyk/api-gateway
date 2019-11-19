# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbService::FieldMapping, type: :model do
  describe 'database columns' do
    it { should have_db_column(:endpoint_id).of_type(:integer) }
    it { should have_db_column(:partner_field_id).of_type(:integer) }
    it { should have_db_column(:vip_field_id).of_type(:integer) }
    it { should have_db_column(:translation_needed).of_type(:boolean) }
    it { should have_db_column(:required).of_type(:boolean) }
    it { should have_db_column(:translation_function).of_type(:string) }
  end

  describe 'validations' do
  end

  describe 'associations' do
    it { should belong_to(:partner_field) }
    it { should belong_to(:vip_field) }
  end
end
