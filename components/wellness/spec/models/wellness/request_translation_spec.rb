# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe RequestTranslation, type: :model do
    describe 'translation' do
      context 'regular translation' do
        let(:mapper_file_name) { 'mapper.json' }
        let(:request_mapper_path) { Rails.root.join('../../lib/mappers/vip', mapper_file_name) }
        let(:request_mapper) { JSON.parse(File.read(request_mapper_path)) }
        let(:request_file_name) { 'contract_applications_vip_request.json' }
        let(:request_path) { Rails.root.join('../../spec/helpers/dummy_docs/contract_applications', request_file_name) }
        let(:request) { JSON.parse(File.read(request_path)) }
        subject { RequestTranslation.new(request) }
        it 'translates request' do
          allow_any_instance_of(RequestTranslation).to receive(:parse_request) { request }
          allow_any_instance_of(RequestTranslation).to receive(:translate_cc_fields)
          translated_fields = subject.translate_request.keys
          fields = %w[location plan paymentaddressSameAsAccount payOption portalUsername phone1Type]
          fields.each do |field|
            expect(translated_fields).to include(field)
          end
        end
      end
      context 'skip default translation' do
        let(:mapper_file_name) { 'mapper.json' }
        let(:request_mapper_path) { Rails.root.join('../../lib/mappers/vip', mapper_file_name) }
        let(:request_mapper) { JSON.parse(File.read(request_mapper_path)) }
        let(:request_file_name) { 'contract_applications_vip_request.json' }
        let(:request_path) { Rails.root.join('../../spec/helpers/dummy_docs/contract_applications', request_file_name) }
        let(:request) { JSON.parse(File.read(request_path)) }
        subject { RequestTranslation.new(request, skip_default: true) }
        it 'skips default fields' do
          allow_any_instance_of(RequestTranslation).to receive(:parse_request) { request }
          allow_any_instance_of(RequestTranslation).to receive(:translate_cc_fields)
          translated_fields = subject.translate_request.keys
          fields = %w[location plan phone1Type]
          fields.each do |field|
            expect(translated_fields).to include(field)
          end
        end
      end
    end
  end
end
