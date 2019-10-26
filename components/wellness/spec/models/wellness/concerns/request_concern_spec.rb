require 'rails_helper'

module Wellness
  RSpec.describe Concerns::RequestConcern, type: :model do
    subject { WellnessPlans.new('plans', 'index') }
    describe '#api_request' do
      # VCR Integration test
      context 'integration' do
        let(:required_attr) { %w(ageGroup autoRenew shortDescription species) }
        context 'index' do
          it "connects to api to get token" do
            VCR.use_cassette('login/vcp_login') do
              expect(subject.token).not_to be_nil
            end
          end
          it "returns body" do
            VCR.use_cassette('plans/wellness_plans_raw_body') do
              expect(subject.api_request.first).to include(*required_attr)
            end
          end
        end
      end
    end
  end
end