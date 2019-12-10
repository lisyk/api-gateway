# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Constructors::ContractAppConstructor, type: :model do
    let(:contract_sample_file) do
      File.read(File.expand_path('../../../helpers/dummy_docs/contract_applications/contract_applications_sample.json', __dir__))
    end
    let(:field_mapper_file) do
      File.read(File.expand_path('../../../../lib/mappers/contract_app_mapper.json', __dir__))
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
    subject { Constructors::ContractAppConstructor.new(contracts_sample, field_mapper, params) }
    describe '#modify' do
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
        blank_plan_constructor = Constructors::PlanConstructor.new({}, field_mapper, params)
        expect(blank_plan_constructor.modify).to eq(message: ['No plans matched query'])
      end
      it 'refines exposed values' do
        modified_plan_list = subject.modify
        ignored_fields.each do |ignored_field|
          expect(modified_plan_list).not_to include ignored_field
        end
      end
    end
  end
end
