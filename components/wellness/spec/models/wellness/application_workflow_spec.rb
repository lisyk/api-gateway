# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe ApplicationWorkflow, :vcr, type: :model do
    describe 'singleton methods' do
      context 'validate_submission' do
        let(:valid_submission) do
          {
            'id' => '1',
            'externalMemberCd' => '1'
          }
        end
        let(:invalid_submission) do
          {
            'errors' => 'invalid'
          }
        end
        let(:workflow) { ApplicationWorkflow.new }
        it 'returns true for valid response' do
          expect(workflow.validate_submission(valid_submission)).to be true
        end

        it 'returns false for invalid response' do
          expect(workflow.validate_submission(invalid_submission)).to be false
        end
      end
    end
  end
end
