# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DbService::Endpoint, type: :model do
  describe 'database columns' do
    shared_examples 'endpoints db columns' do |column, type|
      it { should have_db_column(column.to_s).of_type(type.to_s) }
    end

    it_behaves_like 'endpoints db columns', 'partner_id', 'integer'
    it_behaves_like 'endpoints db columns', 'endpoint_name', 'string'
    it_behaves_like 'endpoints db columns', 'protocol', 'string'
    it_behaves_like 'endpoints db columns', 'subdomain', 'string'
    it_behaves_like 'endpoints db columns', 'api_route', 'string'
  end

  describe 'validations' do
    it { should validate_presence_of(:endpoint_name) }
    it { should validate_presence_of(:protocol) }
  end

  describe 'associations' do
    it { should belong_to(:partner) }
  end
end
