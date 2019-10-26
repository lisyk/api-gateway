require 'rails_helper'

module Wellness
  RSpec.describe Constructors::PlanConstructor, type: :model do
    let(:plans_sample_file) { File.read(File.expand_path('../../helpers/dummy_docs/plans/origin_plans_sample.json', __dir__)) }
    let(:plans_sample) { JSON.parse plans_sample_file }
    #TODO connect to real methods to make it fails once changes
    let(:species_modifier_rule) { 'species' }
    let(:age_group_modifier_rule) { nil }
    let(:sex_modofier_rule) { nil }
    let(:constructor_mapper) {
      {
        'species' => species_modifier_rule,
        'age_group' => age_group_modifier_rule,
        'sex' => sex_modofier_rule
      }
    }
    subject { Constructors::PlanConstructor.new(plans_sample, constructor_mapper) }
    describe '#modify' do
      it 'returns plans with custom attributes' do
        expect(subject.modify.first).to include "vip_mapped_attributes"
        expect(subject.modify.last).to include "vip_mapped_attributes"
      end
    end
  end
end