# frozen_string_literal: true

module Wellness
  class VerifyS3BucketJob < ApplicationJob
    include Services::AwsS3Service

    queue_as :default

    def perform(*_args)
      response = connection.client.send(:get, 'contract')
      parsed_response = JSON.parse(response.body)
      errors = verify_s3_contents(parsed_response)
      return unless errors.any?

      reconcile_agreements(errors)
    end

    private

    def connection
      Wellness::Connect.new
    end

    def verify_s3_contents(response)
      response.map do |contract|
        id = contract['id'].to_s if contract['id'].present?
        next if id.nil? || s3_objects.any? { |file| file.key.match?(id) }

        { id: id, message: "Agreement with ID #{id} not present in S3 bucket." }
      end.compact
    end

    def reconcile_agreements(errors)
      errors.each do |error|
        agreement_id = error[:id]
        document = download_document(agreement_id)
        upload_document(agreement_id, document)
      end
    end

    def s3_objects
      s3_bucket.objects.to_a
    end

    def download_document(id)
      response = connection.client.send(:get, "contractApplicationAgreement/#{id}")
      Base64.strict_encode64(response.body)
    end

    def upload_document(agreement_id, document)
      s3_bucket.object("#{agreement_id}.pdf").put(body: document)
    end
  end
end
