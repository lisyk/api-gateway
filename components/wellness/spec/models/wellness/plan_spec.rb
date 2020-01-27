# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Plan, :vcr, type: :model do
    subject { Plan.new('plans', 'index') }
    describe '#plans_mapping' do
      # VCR Integration test
      context 'integration' do
        context 'index' do
          it 'connects to api to get token' do
            expect(subject.token).not_to be_nil
          end
        end
      end
    end
  end
end
