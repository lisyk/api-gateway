# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe Constructors::PlanConstructor, type: :model do
    let(:plans_sample_file) do
      File.read(File.expand_path('../../../helpers/dummy_docs/plans/origin_plans_sample.json', __dir__))
    end
    let(:field_mapper_file) do
      File.read(File.expand_path('../../../../lib/mappers/plans/plan_mapper.json', __dir__))
    end
    let(:plans_sample) { JSON.parse plans_sample_file }
    let(:field_mapper) { JSON.parse field_mapper_file }
    let(:params) { {} }
    let(:ignored_fields) do
      %w[
        renewalPlan
        planType
        productSubType
        locationId
        planEffectiveDate
        planExpirationDate
        planStatus
      ]
    end
    subject { Constructors::PlanConstructor.new(plans_sample, field_mapper, params) }
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
        blank_plan_constructor = Constructors::PlanConstructor.new({}, field_mapper, params)
        expect(blank_plan_constructor.modify).to eq(message: ['No plans matched query'])
      end
      it 'refines exposed values' do
        modified_plan_list = subject.modify
        ignored_fields.each do |ignored_field|
          expect(modified_plan_list).not_to include ignored_field
        end
      end
      context 'filter results' do
        let(:clinic_params) { { clinic_location_id: '010265' } }
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
        before do
          allow_any_instance_of(Constructors::PlanConstructor).to receive(:update_nested_field_names) { nil }
          allow_any_instance_of(Constructors::PlanConstructor).to receive(:translate) { nil }
          allow_any_instance_of(Services::PlanFilterService).to receive(:age_groups) { age_groups }
        end
        context 'by clinic location id' do
          it 'returns plans filtered by clinic' do
            field_mapper['location'] = 'location'
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, clinic_params)
            filter.modify.each do |item|
              expect(item['location']['externalLocationCd']).to eq clinic_params[:clinic_location_id]
            end
          end
        end
        context 'by sellable' do
          it 'returns plans filtered by sellable' do
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, sellable_params)
            filter.modify.each do |item|
              expect(item['planStatus']).not_to be 'I'
            end
          end
          it 'returns plans filtered by not sellable' do
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, not_sellable_params)
            filter.modify.each do |item|
              expect(item['plansStatus']).not_to be 'A'
            end
          end
        end
        context 'by species' do
          it 'returns plans filtered by single species' do
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, single_species_params)
            filter.modify.each do |item|
              expect(item['species']).to_not be 2
            end
          end
          it 'returns plans filtered by multiple species' do
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, multiple_species_params)
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
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, age_params)
            filter.modify.each do |item|
              expect(item['ageGroup'] % 10).to eq age_group
            end
          end
          it 'returns plans filtered by age as YY/MM formatted string' do
            age_months = rand(13)
            age_params = { age: "#{@age}Y #{age_months}M" }
            age_group = age_groups.select { |_k, v| v <= ((age_months / 12).floor + @age) }.max.first.to_i
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, age_params)
            filter.modify.each do |item|
              expect(item['ageGroup'] % 10).to eq age_group
            end
          end
          it 'returns plans filtered by age as int' do
            age_params = { age: @age }
            age_group = age_groups.select { |_k, v| v <= @age }.max.first.to_i
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, age_params)
            filter.modify.each do |item|
              expect(item['ageGroup'] % 10).to eq age_group
            end
          end
        end
        context 'by multiple params' do
          it 'returns plans filtered by options' do
            all_params = {
              clinic_location_id: ['010265', '010264'].sample,
              age: rand(10),
              is_sellable: ['true', 'false'].sample,
              species: ['1', '2', '1,2'].sample
            }
            filter = Constructors::PlanConstructor.new(plans_sample, field_mapper, all_params)
            expect { filter.modify }.not_to raise_error
          end
        end
      end
      it 'translates needed fields' do
        allow(subject).to receive(:translate) { 1 }
        expect(subject.modify.first['age_group']).to eq(1)
      end
    end
  end
end
