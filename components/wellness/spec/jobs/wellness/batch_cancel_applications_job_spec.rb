# frozen_string_literal: true

require 'rails_helper'

module Wellness
  RSpec.describe BatchCancelApplicationsJob, type: :job do
    include ActiveJob::TestHelper

    subject(:job) { BatchCancelApplicationsJob.new }

    before :each do
      allow($stdout).to receive(:puts)
      allow($stdout).to receive(:write)
      body = (0..9).map do
        { id: 'test_id', status: '1' }
      end
      applications_list = Rack::MockResponse.new(200, {}, body.to_json)
      allow(job).to receive(:fetch_open_applications).and_return applications_list
      allow(job).to receive(:send_cancellation_request).and_return Rack::MockResponse.new(200, {}, {})
    end
    it 'queues as default' do
      expect(VerifyS3BucketJob.new.queue_name).to eq 'default'
    end
    it 'cancels contracts with open status' do
      job.perform_now
      expect(job.results[:success]).to eq 10
    end
    it 'ignores contracts that cannot be canceled' do
      body = (0..9).map do
        { id: 'test_id', status: %w[0 5 7].sample }
      end
      applications_list = Rack::MockResponse.new(200, {}, body.to_json)
      allow(job).to receive(:fetch_open_applications).and_return applications_list
      job.perform_now
      expect(job.results[:success]).to eq 0
    end
    it 'ignores contracts that do not match status' do
      body = (0..9).map do
        { id: 'test_id', status: '1' }
      end
      applications_list = Rack::MockResponse.new(200, {}, body.to_json)
      allow_any_instance_of(BatchCancelApplicationsJob).to receive(:fetch_open_applications).and_return applications_list
      job = BatchCancelApplicationsJob.new(status: [20])
      job.perform_now
      expect(job.results[:success]).to eq 0
    end
    it 'correctly sets date' do
      body = (0..9).map do
        { id: 'test_id', status: '5' }
      end
      applications_list = Rack::MockResponse.new(200, {}, body.to_json)
      allow_any_instance_of(BatchCancelApplicationsJob).to receive(:fetch_open_applications).and_return applications_list
      job = BatchCancelApplicationsJob.new(last_updated_before_date: DateTime.current)
      job.perform_now
      expect(job.last_updated_before_date).to eq DateTime.current.strftime('%Y-%m-%d')
    end
    it 'updates errors' do
      allow(job).to receive(:send_cancellation_request).and_return Rack::MockResponse.new(422, {}, {})
      job.perform_now
      expect(job.results[:errors].size).to eq 10
    end
    after do
      clear_enqueued_jobs
      clear_performed_jobs
    end
  end
end
