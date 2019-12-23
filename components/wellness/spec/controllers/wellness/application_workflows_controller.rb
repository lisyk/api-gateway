# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe ApplicationWorkflowsController, type: :controller do
    routes { Wellness::Engine.routes }

    describe 'PUT #update' do
      let(:put_agreement_sample_file) { File.read(File.expand_path('../../helpers/dummy_docs/contracts/contract.pdf', __dir__)) }
      let(:put_agreement) { put_agreement_sample_file }

      context 'authenticated' do
        before :each do
          allow(controller).to receive(:authenticate!)
          controller.instance_variable_set(:@current_user, 'authorized')
        end
      #   describe 'agreement available' do
      #     before do
      #       allow(controller).to receive(:put_agreement).and_return('Success')
      #       stub_const('Settings', route_settings)
      #     end
      #     it 'returns correct upload message' do
      #       put :update, params: { id: '1000008890' }
      #       expect(response).to have_http_status(200)
      #       expect(JSON.parse(response.body)['errors']).to be_nil
      #       expect(JSON.parse(response.body)).not_to be_nil
      #     end
      #   end
      # end
      # context 'not authenticated' do
      #   before do
      #     allow(controller).to receive(:authenticate!)
      #     controller.instance_variable_set(:@current_user, nil)
      #   end
      #   it 'sends error message to the client' do
      #     put :update, params: { id: '1000008890' }
      #     expect(response).to have_http_status(403)
      #     expect(JSON.parse(response.body)['errors']).to include 'You are not authorized'
      #   end
      #   it "doesn't assign response" do
      #     expect(assigns(:response)).to be_nil
        end
      end
    end
  end
end