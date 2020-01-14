# frozen_string_literal: true

module Wellness
  class VerifyS3BucketJob < ApplicationJob
    include Services::AwsS3Service
    include Services::S3BucketJobMessageService

    queue_as :default

    def perform(*_args)
      start_job
      response = connection.client.send(:get, 'contract')
      new_contracts = JSON.parse(response.body)
      @status = status_template
      errors = verify_s3_contents(new_contracts)
      reconcile_agreements(errors) if errors.any?
      finish_job
      display_results
    end

    private

    def connection
      Wellness::Connect.new
    end

    def status_template
      { count: new_contracts.size, nil_id: 0, dl_failed: [], ul_failed: [], found: [] }
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
      response = connection.client.send(:get, "contractApplicationAgreement/#{id}")
      if response.status == 200
        puts 'Success'
        return Base64.strict_encode64(response.body)
      else
        puts 'Failed'
        message[:dl_failed] << id
      end
      nil
    end

    def upload_document(agreement_id, document)
      print "#{DateTime.current}: Uploading agreement to S3 for ID##{id}... "
      upload = s3_bucket.object("#{agreement_id}.pdf").put(body: document)
      if upload.etag.present?
        puts 'Success'
      else
        puts 'Failed'
        message[:ul_failed] << id
      end
    end
  end
end
