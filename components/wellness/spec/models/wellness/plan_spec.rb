# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Plan, :vcr, type: :model do
    subject { Plan.new('plans', 'index') }
    describe '#plans_mapping' do
      # VCR Integration test
      context 'integration' do
        let(:required_attr) { ['vip_mapped_attributes' => { 'age_group' => nil, 'sex' => nil, 'species' => 1 }] }
        context 'index' do
          it 'connects to api to get token' do
            expect(subject.token).not_to be_nil
          end
          it 'returns body' do
            expect(subject.plans_mapping.first).to include(*required_attr)
          end
        end
      end
    end
  end
end
