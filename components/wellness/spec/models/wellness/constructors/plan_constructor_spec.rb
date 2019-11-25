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
    let(:params) { {} }
    subject { Constructors::PlanConstructor.new(plans_sample, constructor_mapper, params) }
    describe '#modify' do
      before do
        allow(constructor_mapper).to receive(:plan_mapping) { partner_mapping_object }
      end
      it 'returns plans with custom attributes' do
        expect(subject.modify.first).to include 'age_group'
      end
      context 'filter results' do
        before do
          allow(constructor_mapper).to receive(:plan_mapping) { nil }
        end
        let(:sellable_params) { { is_sellable: 'true' } }
        let(:not_sellable_params) { { is_sellable: 'false' } }
        let(:single_species_params) { { species: '1' } }
        let(:multiple_species_params) { { species: '1,2' } }
        let(:age_groups) do
          {
            '1' => 0,
            '2' => 1,
            '3' => 3,
            '4' => 7
          }
        end
        context 'by sellable' do
          it 'returns plans filtered by sellable' do
            filter = Constructors::PlanConstructor.new(plans_sample, constructor_mapper, sellable_params)
            filter.modify.each do |item|
              expect(item['planStatus']).not_to be 'I'
            end
          end
          it 'returns plans filtered by not sellable' do
            filter = Constructors::PlanConstructor.new(plans_sample, constructor_mapper, not_sellable_params)
            filter.modify.each do |item|
              expect(item['planStatus']).not_to be 'A'
            end
          end
        end
        context 'by species' do
          it 'returns plans filtered by single species' do
            filter = Constructors::PlanConstructor.new(plans_sample, constructor_mapper, single_species_params)
            filter.modify.each do |item|
              expect(item['species']).to_not be 2
            end
          end
          it 'returns plans filtered by multiple species' do
            filter = Constructors::PlanConstructor.new(plans_sample, constructor_mapper, multiple_species_params)
            filter.modify.each do |item|
              expect(item['species']).to eq(1) | eq(2)
            end
          end
        end
        context 'by age' do
          before do
            @age = rand(10)
          end
          it 'returns plans filtered by age as datetime' do
            age_params = { age: (DateTime.current - @age.years).to_s }
            age_group = age_groups.select { |_k, v| v <= @age }.max.first.to_i
            filter = Constructors::PlanConstructor.new(plans_sample, constructor_mapper, age_params)
            filter.modify.each do |item|
              expect(item['ageGroup'] % 10).to eq age_group
            end
          end
          it 'returns plans filtered by age as YY/MM formatted string' do
            age_months = rand(13)
            age_params = { age: "#{@age}Y #{age_months}M" }
            age_group = age_groups.select { |_k, v| v <= @age }.max.first.to_i
            filter = Constructors::PlanConstructor.new(plans_sample, constructor_mapper, age_params)
            filter.modify.each do |item|
              expect(item['ageGroup'] % 10).to eq age_group
            end
          end
          it 'returns plans filtered by age as int' do
            age_params = { age: @age }
            age_group = age_groups.select { |_k, v| v <= @age }.max.first.to_i
            filter = Constructors::PlanConstructor.new(plans_sample, constructor_mapper, age_params)
            filter.modify.each do |item|
              expect(item['ageGroup'] % 10).to eq age_group
            end
          end
        end
      end
    end
  end
end
