# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe RequestTranslation, type: :model do
    describe 'translation' do
      context 'contract applications' do
        let(:mapper_file_name) { 'contract_applications_request_mapper.json' }
        let(:request_mapper_path) { Rails.root.join('../../lib/mappers/contract_applications', mapper_file_name) }
        let(:request_mapper) { JSON.parse(File.read(request_mapper_path)) }
        let(:request_file_name) { 'contract_applications_vip_request.json' }
        let(:request_path) { Rails.root.join('../../spec/helpers/dummy_docs/contract_applications', request_file_name) }
        let(:request) { JSON.parse(File.read(request_path)) }
        subject { RequestTranslation.new(request, 'contract_applications') }
        it 'translates request' do
          allow_any_instance_of(RequestTranslation).to receive(:parse_request)
          allow_any_instance_of(RequestTranslation).to receive(:translate_cc_fields)
          subject.request = request
          subject.translation_type = 'contract_applications'
          translated_request = subject.translate_request
          request_mapper.keys.each do |key|
            expect(translated_request.keys).to include(request_mapper[key])
          end
        end
      end
    end
  end
end
