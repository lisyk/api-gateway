require 'rails_helper'

RSpec.describe DbService::Endpoint, type: :model do
  describe 'associations' do
    it { should belong_to(:partner) }
  end

  context 'presence' do

  end
end
