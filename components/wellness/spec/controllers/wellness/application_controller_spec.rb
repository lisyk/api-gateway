# frozen_string_literal: true

require 'rails_helper'
require(File.expand_path('../../app/controllers/api/v1/api_controller'))

module Wellness
  RSpec.describe ApplicationController do
    describe '#convert_url_pet_id' do
      it 'contacts partner for contract_id if given pet_id' do
        allow(controller).to receive(:params).and_return(id: 'd525ffb5-d627-41f9-a317-86a205a9e130')
        allow(controller).to receive(:contract_app_id_client).and_return FaradayMock.new('123456789')
        controller.convert_url_pet_id
        expect(controller.params).to include :id
        expect(controller.params[:id]). to eq '123456789'
      end
      it 'does nothing if contract_id given' do
        allow(controller).to receive(:params).and_return(id: '123456789')
        controller.convert_url_pet_id
        expect(controller).not_to receive(:contract_app_id_client)
        expect(controller.params).to include :id
        expect(controller.params[:id]). to eq '123456789'
      end
      it 'does nothing in case of non-UUID string' do
        allow(controller).to receive(:params).and_return(id: 'bad_uuid_string')
        controller.convert_url_pet_id
        expect(controller).not_to receive(:contract_app_id_client)
        expect(controller.params).to include :id
        expect(controller.params[:id]). to eq 'bad_uuid_string'
      end
    end

    class FaradayMock
      def initialize(id)
        @id = id
      end

      def get
        Rack::MockResponse.new(200, {}, [{ 'externalMemberCd' => @id }].to_json)
      end
    end
  end
end
