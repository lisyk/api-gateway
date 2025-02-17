# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Concerns::RequestConcern, :vcr, type: :model do
    subject { Plan.new('plans', 'index') }
    describe '#api_request' do
      # VCR Integration test
      context 'integration' do
        let(:required_attr) { ['ageGroup', 'autoRenew', 'shortDescription', 'species'] }
        context 'index' do
          it 'connects to api to get token' do
            expect(subject.token).not_to be_nil
          end
          it 'returns body' do
            expect(subject.api_request.first).to include(*required_attr)
          end
        end
      end
    end
  end
end
