# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe ApplicationWorkflow, :vcr, type: :model do
    describe 'singleton methods' do
      context 'validate_finalization_request' do
        let(:valid_submission) do
          {
            'initialPaymentOption' => '12',
            'accountNbr' => '1'
          }
        end
        let(:invalid_submission) do
          {
            'errors' => 'invalid'
          }
        end
        let(:workflow) { ApplicationWorkflow.new }
        it 'returns true for valid response' do
          expect(workflow.validate_finalization_request(valid_submission)).to be true
        end
        it 'returns false for invalid response' do
          expect(workflow.validate_finalization_request(invalid_submission)).to be false
        end
      end
    end
  end
end
