# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe DbEngineInteractor, type: :model do
    describe 'singleton methods' do
      context 'call' do
        describe 'record exists' do
          before do
            allow(DbEngineInteractor).to receive(:find_contract).and_return('fake_record')
            allow(DbEngineInteractor).to receive(:update_record).and_return 'record updated'
          end
          it 'updates existing record' do
            expect(DbEngineInteractor.call(pet_id: '12355', contract_app_id: '2346')).to eq 'record updated'
          end
        end
        describe 'record does not exist' do
          before do
            allow(DbEngineInteractor).to receive(:find_contract).and_return false
            allow(DbEngineInteractor).to receive(:create_record).and_return 'record created'
          end
          it 'updates existing record' do
            expect(DbEngineInteractor.call(pet_id: '12355', contract_app_id: '2346')).to eq 'record created'
          end
        end
      end
    end
  end
end
