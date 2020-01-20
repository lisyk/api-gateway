# frozen_string_literal: true

module Wellness
  class VerifyS3BucketJob < ApplicationJob
    include Services::AwsS3Service
    include Services::S3BucketJobMessageService

    attr_reader :status

    queue_as :default

    def perform(*_args)
      start_job
      response = fetch_new_contracts
      new_contracts = JSON.parse(response.body)
      @status = status_template(new_contracts)
      errors = verify_s3_contents(new_contracts)
      reconcile_agreements(errors) if errors.any?
      finish_job
      display_results
    end

    private

    def connection
      Wellness::Connect.new
    end

    def fetch_new_contracts
      connection.client.send(:get, 'contract')
    end

    def fetch_agreement(id)
      connection.client.send(:get, "contractApplicationAgreement/#{id}")
    end

    def s3_upload(id, document)
      s3_bucket.object("#{id}.pdf").put(body: document)
    end

    def status_template(contracts)
      { count: contracts.size, nil_id: 0, dl_failed: [], ul_failed: [], found: [] }
    end

    def verify_s3_contents(contracts)
      contracts.map do |contract|
        id = contract['id'].to_s if contract['id'].present?
        if id && s3_objects.any? { |file| file.key.match?(id) }
          @status[:found] << id
          next
        end

        @status[:nil_id] += 1 if id.nil?
        id
      end.compact
    end

    def reconcile_agreements(error_ids)
      error_ids.each do |id|
        document = download_document(id)
        next if document.nil?

        upload_document(id, document)
      end
    end

    def s3_objects
      s3_bucket.objects.to_a
    end

    def download_document(id)
      print "#{DateTime.current}: Downloading agreement from partner for ID##{id}... "
      response = fetch_agreement(id)
      if response.status == 200
        puts 'Success'
        return Base64.strict_encode64(response.body)
      else
        puts 'Failed'
        @status[:dl_failed] << id
      end
      nil
    end

    def upload_document(id, document)
      print "#{DateTime.current}: Uploading agreement to S3 for ID##{id}... "
      upload = s3_upload(id, document)
      if upload.etag.present?
        puts 'Success'
      else
        puts 'Failed'
        @status[:ul_failed] << id
      end
    end
  end
end
