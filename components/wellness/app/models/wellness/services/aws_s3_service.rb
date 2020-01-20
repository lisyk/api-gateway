# frozen_string_literal: true

require 'aws-sdk-s3'

module Wellness
  module Services
    module AwsS3Service
      attr_reader :id, :document

      def store_agreement(messages = {})
        response = upload_document
        if response.etag.present?
          merge_messages(messages, success_msg, :ok)
        else
          merge_messages(messages, error_msg, :error)
        end
      rescue StandardError => e
        merge_messages(messages, { errors: [e.message] }, :error)
      end

      def upload_document
        s3_object.put(body: document)
      end

      private

      def s3_object
        s3_bucket.object("#{agreement_id}.pdf")
      end

      def s3_bucket
        Aws::S3::Resource.new.bucket(ENV['AWS_BUCKET_NAME'])
      end

      def merge_messages(messages, storage_msg, status)
        messages = default_message(status) if messages.blank?

        storage_msg.each do |key, val|
          messages = update_messages(messages, key, val)
        end
        messages[:status] = overall_status(messages[:status], status)
        messages[:messages].delete :status
        messages
      end

      def update_messages(messages, key, val)
        if messages[:messages][key].present?
          messages[:messages][key] << val.first
        else
          messages[:messages][key] = val
        end
        messages
      end

      def default_message(status)
        { messages: {}, status: status }
      end

      def overall_status(first_status, second_status)
        return :multi_status if first_status != second_status
        return :ok if first_status == :ok

        :unprocessable_entity
      end

      def success_msg
        { success: ['Agreement stored in S3 bucket successfully.'] }
      end

      def error_msg
        { errors: ['Agreement not stored in S3 bucket.'] }
      end
    end
  end
end
