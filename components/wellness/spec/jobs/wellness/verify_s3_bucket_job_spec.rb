# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe VerifyS3BucketJob, type: :job do
    include ActiveJob::TestHelper

    subject(:job) { VerifyS3BucketJob.new }

    before :each do
      body = (0..9).map do
        { id: 'test_id' }
      end.to_json
      contracts_list = Rack::MockResponse.new(200, {}, body)
      allow(job).to receive(:fetch_new_contracts).and_return contracts_list
      agreement_response = Rack::MockResponse.new(200, {}, 'document')
      allow(job).to receive(:fetch_agreement).and_return agreement_response
      @stub_s3_bucket = Aws::S3::Resource.new(stub_responses: true)
                                         .bucket('wpi')
      stub_s3_upload = @stub_s3_bucket.object('test_id.pdf')
                                      .put(body: 'document')
      allow(job).to receive(:s3_upload).and_return stub_s3_upload
      stub_s3_objects = Array.new(10, @stub_s3_bucket.object('test_id.pdf'))
      allow(job).to receive(:s3_objects).and_return stub_s3_objects
    end
    it 'queues as default' do
      expect(VerifyS3BucketJob.new.queue_name).to eq 'default'
    end
    it 'updates found status for ids in S3' do
      job.perform_now
      expect(job.status[:found].size).to eq 10
    end
    it 'does not update found status for ids not in S3' do
      contracts = (0..9).map do
        { id: 'not_found' }
      end.to_json
      contracts_list = Rack::MockResponse.new(200, {}, contracts)
      allow(job).to receive(:fetch_new_contracts).and_return contracts_list
      job.perform_now
      expect(job.status[:found].size).to eq 0
    end
    it 'calls to download/upload for ids not in S3' do
      contracts = (0..9).map do |i|
        { id: "not_found_#{i}" }
      end.to_json
      contracts_list = Rack::MockResponse.new(200, {}, contracts)
      allow(job).to receive(:fetch_new_contracts).and_return contracts_list
      agreement_response = Rack::MockResponse.new(200, {}, 'document')
      expect(job).to receive(:download_document).and_return(agreement_response).exactly(10).times
      expect(job).to receive(:upload_document).exactly(10).times
      job.perform_now
    end
    it 'updates nil count for nil ids' do
      contracts = (0..9).map do
        { id: nil }
      end.to_json
      contracts_list = Rack::MockResponse.new(200, {}, contracts)
      allow(job).to receive(:fetch_new_contracts).and_return contracts_list
      job.perform_now
      expect(job.status[:nil_id]).to eq 10
    end
    it 'stores a list of ids that could not be downloaded' do
      contracts = (0..9).map do
        { id: 'fake_id' }
      end.to_json
      contracts_list = Rack::MockResponse.new(200, {}, contracts)
      allow(job).to receive(:fetch_new_contracts).and_return contracts_list
      failed_download = Rack::MockResponse.new(422, {}, '')
      allow(job).to receive(:fetch_agreement).and_return failed_download
      job.perform_now
      expect(job.status[:dl_failed]).to be_an Array
      expect(job.status[:dl_failed]).to include 'fake_id'
      expect(job.status[:dl_failed].size).to eq 10
    end
    it 'stores a list of ids that could not be uploaded' do
      contracts = (0..9).map do
        { id: 'fake_id' }
      end.to_json
      contracts_list = Rack::MockResponse.new(200, {}, contracts)
      allow(job).to receive(:fetch_new_contracts).and_return contracts_list
      failed_upload = Rack::MockResponse.new(422, {}, '')
      allow(job).to receive(:s3_upload).and_return failed_upload
      job.perform_now
      expect(job.status[:ul_failed]).to be_an Array
      expect(job.status[:ul_failed]).to include 'fake_id'
      expect(job.status[:ul_failed].size).to eq 10
    end
    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end
  end
end
