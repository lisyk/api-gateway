# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))
require 'redis'

module Wellness
  RSpec.describe PlanAgreementsController, type: :controller do
    routes { Wellness::Engine.routes }
    let(:settings_yaml) { YAML.safe_load(File.read(File.expand_path('../../../../config/settings/test.yml', Rails.root))) }
    let(:settings_convert) { settings_yaml.to_json }
    let(:settings) { JSON.parse(settings_convert, object_class: OpenStruct) }

    describe '#show' do
      context 'correct credentials' do
        before :each do
          controller.instance_variable_set(:@current_user, 'authorized')
          allow(controller).to receive(:authenticate!).and_return true
          stub_const('Settings', settings)
        end
        xit 'responds with PDF' do
          VCR.use_cassette('contract/vcp_agreement_auth') do
            get :show, params: { id: '1000008890' }
          end
          expect(response).to have_http_status(200)
          expect(response.content_type).to eq 'application/pdf'
        end
      end

      context 'incorrect credentials' do
        before { allow(controller).to receive(:authenticate!).and_return false }
        it 'sends error message to the client' do
          request.headers.merge!('Authorization' => '')
          VCR.use_cassette('vcp_agreement_no_auth') do
            get :show, params: { id: '1000008890' }
          end
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
