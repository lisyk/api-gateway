# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Constructors::PlanConstructor, type: :model do
    let(:plans_sample_file) do
      File.read(File.expand_path('../../../helpers/dummy_docs/plans/origin_plans_sample.json', __dir__))
    end
    let(:plans_sample) { JSON.parse plans_sample_file }
    let(:constructor_mapper) { double }
    let(:vip_field) { OpenStruct.new(field_name: 'age_group') }
    let(:partner_mapping_object) { [OpenStruct.new(vip_field: vip_field)] }
    subject { Constructors::PlanConstructor.new(plans_sample, constructor_mapper) }
    describe '#modify' do
      before do
        allow(constructor_mapper).to receive(:plan_mapping) { partner_mapping_object }
      end
      it 'logs the unaltered response' do
        expect(Rails.logger).to receive(:info).with(/Original Response\:/)
        subject.modify
      end
      it 'returns plans with custom attributes' do
        expect(subject.modify.first).to include 'age_group'
      end
      it 'returns blank object if plan is missing' do
        blank_plan_constructor = Constructors::PlanConstructor.new({}, constructor_mapper)
        expect(blank_plan_constructor.modify).to eq({})
      end
    end
  end
end
