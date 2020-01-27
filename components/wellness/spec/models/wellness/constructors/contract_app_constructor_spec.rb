# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Constructors::ContractAppConstructor, type: :model do
    let(:contract_sample_file) do
      File.read(File.expand_path('../../../helpers/dummy_docs/contract_applications/contract_applications_sample.json', __dir__))
    end
    let(:field_mapper_file) do
      File.read(File.expand_path('../../../../lib/mappers/contract_applications/contract_applications_response_mapper.json', __dir__))
    end
    let(:contracts_sample) { JSON.parse contract_sample_file }
    let(:field_mapper) { JSON.parse field_mapper_file }
    let(:params) { {} }
    let(:ignored_fields) do
      %w[
        salutation
        middleInitial
        initiatedByProfessionalId
        primaryCareProfessionalId
        initiatedByProfessionalCd
        primaryCareProfessionalCd
      ]
    end
    subject { Constructors::ContractAppConstructor.new(contracts_sample, params) }
    describe '#modify' do
      before do
        allow(subject).to receive(:translate) { nil }
      end
      it 'logs the unaltered response' do
        expect(Rails.logger).to receive(:info).with(/Original Response\:/)
        subject.modify
      end
      it 'returns plans with custom attributes' do
        expect(subject.modify.first).to include 'owner_first_name'
      end
      it 'returns plans with custom attributes' do
        expect(subject.modify.first).not_to include 'salutation'
      end
      it 'returns blank object if plan is missing' do
        blank_plan_constructor = Constructors::PlanConstructor.new({}, params)
        expect(blank_plan_constructor.modify).to eq(message: ['No plans matched query'])
      end
      it 'refines exposed values' do
        modified_plan_list = subject.modify
        ignored_fields.each do |ignored_field|
          expect(modified_plan_list).not_to include ignored_field
        end
      end
      it 'translates needed fields' do
        allow(subject).to receive(:translate) { 1 }
        expect(subject.modify.first['card_name']).to eq(1)
      end
      context 'map phone fields' do
        before do
          @sample_contract = contracts_sample.dup
          %w[phone1Type phone2 phone2Type].each do |key|
            @sample_contract.first.delete key
          end
          @sample_contract.first['phone1'] = '1234567890'
        end
        it 'returns mobile field if phoneType is M' do
          phone_sample = @sample_contract.dup
          phone_sample.first['phone1Type'] = 'M'
          subject = Constructors::ContractAppConstructor.new(phone_sample, params)
          allow(subject).to receive(:translate) { nil }
          expect(subject.modify.first['mobile']).to eq('1234567890')
        end
        it 'returns phone field if phoneType not M' do
          phone_sample = @sample_contract.dup
          phone_sample.first['phone1Type'] = ['H', 'W'].sample
          subject = Constructors::ContractAppConstructor.new(phone_sample, params)
          allow(subject).to receive(:translate) { nil }
          expect(subject.modify.first['phone']).to eq('1234567890')
        end
        it 'returns 2 fields if 2 phoneTypes are M' do
          phone_sample = @sample_contract.dup
          phone_sample.first['phone1Type'] = 'M'
          phone_sample.first['phone2'] = '0987654321'
          phone_sample.first['phone2Type'] = 'M'
          subject = Constructors::ContractAppConstructor.new(phone_sample, params)
          allow(subject).to receive(:translate) { nil }
          modified_contract = subject.modify.first
          expect(modified_contract['mobile']).to eq('1234567890')
          expect(modified_contract['alternate_phone']).to eq('0987654321')
        end
        it 'returns 2 fields, not mobile, if 2 phoneTypes not M' do
          phone_sample = @sample_contract.dup
          phone_sample.first['phone1Type'] = ['H', 'W'].sample
          phone_sample.first['phone2'] = '0987654321'
          phone_sample.first['phone2Type'] = ['H', 'W'].sample
          subject = Constructors::ContractAppConstructor.new(phone_sample, params)
          allow(subject).to receive(:translate) { nil }
          modified_contract = subject.modify.first
          expect(modified_contract['phone']).to eq('1234567890')
          expect(modified_contract['alternate_phone']).to eq('0987654321')
        end
      end
      context 'map address fields' do
        before do
          @sample_contract = contracts_sample.dup
          %w[address1 address2].each do |key|
            @sample_contract.first[key] = ' address field '
          end
        end
        it 'returns single address field formatted' do
          address_sample = @sample_contract.dup
          subject = Constructors::ContractAppConstructor.new(address_sample, params)
          allow(subject).to receive(:translate) { nil }
          modified_contract = subject.modify.first
          expect(modified_contract['address']).to be_present
          expect(modified_contract['address'].match?(/(^\s)|(\s{2})|(\s$)/)).to eq false
          expect(modified_contract['address']).to eq 'address field address field'
        end
      end
    end
  end
end
