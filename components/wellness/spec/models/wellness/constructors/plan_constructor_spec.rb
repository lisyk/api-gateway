# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Constructors::PlanConstructor, type: :model do
    let(:plans_sample_file) do
      File.read(File.expand_path('../../../helpers/dummy_docs/plans/origin_plans_sample.json', __dir__))
    end
    let(:plans_sample) { JSON.parse plans_sample_file }
    let(:constructor_mapper) { OpenStruct.new("my_key": "my_value").new }
    subject { Constructors::PlanConstructor.new(plans_sample, constructor_mapper) }
    describe '#modify' do
      it 'returns plans with custom attributes' do
        expect(subject.modify.first).to include 'vip_mapped_attributes'
        expect(subject.modify.last).to include 'vip_mapped_attributes'
      end
    end
  end
end
