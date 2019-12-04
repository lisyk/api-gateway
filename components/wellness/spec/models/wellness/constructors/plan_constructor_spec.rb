# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Constructors::PlanConstructor, type: :model do
    let(:plans_sample_file) do
      File.read(File.expand_path('../../../helpers/dummy_docs/plans/origin_plans_sample.json', __dir__))
    end
    let(:field_mapper_file) do
      File.read(File.expand_path('../../../../lib/mappers/vcp_vip_fields.json', __dir__))
    end
    let(:plans_sample) { JSON.parse plans_sample_file }
    let(:field_mapper) { JSON.parse field_mapper_file }
    subject { Constructors::PlanConstructor.new(plans_sample, field_mapper) }
    describe '#modify' do
      before do
        allow(subject).to receive(:translate) { nil }
      end
      it 'logs the unaltered response' do
        expect(Rails.logger).to receive(:info).with(/Original Response\:/)
        subject.modify
      end
      it 'returns plans with custom attributes' do
        expect(subject.modify.first).to include 'age_group'
      end
      it 'returns blank object if plan is missing' do
        blank_plan_constructor = Constructors::PlanConstructor.new({}, field_mapper)
        expect(blank_plan_constructor.modify).to eq({})
      end
      it 'translates needed fields' do
        allow(subject).to receive(:translate) { 1 }
        expect(subject.modify.first['age_group']).to eq(1)
      end
    end
  end
end
