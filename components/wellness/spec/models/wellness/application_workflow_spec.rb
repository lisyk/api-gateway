# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe ApplicationWorkflow, :vcr, type: :model do
    describe 'singleton methods' do
      context 'validate_initialization_response' do
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
          expect(workflow.validate_initialization_response(valid_submission)).to be true
        end

        it 'returns false for invalid response' do
          expect(workflow.validate_initialization_response(invalid_submission)).to be false
        end
      end

      context 'validate_finalization_request' do
        let(:valid_response) do
          {
            'status' => 5
          }
        end
        let(:invalid_response) do
          {
            'errors' => 'invalid'
          }
        end
        let(:workflow) { ApplicationWorkflow.new }
        it 'returns true for valid response' do
          expect(workflow.validate_finalization_request(valid_response)).to be true
        end
        it 'returns false for invalid response' do
          expect(workflow.validate_finalization_request(invalid_response)).to be false
        end
      end
    end
  end
end
