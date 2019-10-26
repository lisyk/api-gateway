require 'rails_helper'

module Wellness
  RSpec.describe WellnessPlans, type: :model do
    describe '#api_request' do
      context 'plans controller' do
        context 'index' do
          it "connects to api to get token" do
            VCR.use_cassette('login/vcp_login') do
              expect(subject.token).not_to be_nil
            end
          end
          it "returns body" do
            VCR.use_cassette('plans/wellness_plans_raw_body') do
              expect(subject.api_request('plans', 'index').first).to include "ageGroup"
            end
          end
        end
      end
    end
    it "returns json wellness plans"
    it "returns plans with species"
    it "returns plans with age_group"
    it "returns plans with "
  end
end
