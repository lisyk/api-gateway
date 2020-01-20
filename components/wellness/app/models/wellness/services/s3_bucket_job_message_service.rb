# frozen_string_literal: true

module Wellness
  module Services
    module S3BucketJobMessageService
      def start_job
        puts '*' * 10 + ' Starting job... ' + '*' * 10
      end

      def finish_job
        puts '*' * 13 + ' Finished! ' + '*' * 13
      end

      def count
        @status[:count]
      end

      def found
        @status[:found]
      end

      def nil_id
        @status[:nil_id]
      end

      def dl_failed
        @status[:dl_failed]
      end

      def ul_failed
        @status[:ul_failed]
      end

      def errors_total
        nil_id + dl_failed.count + ul_failed.count
      end

      def display_results
        display_stats
        return unless errors_total.positive?

        display_errors
      end

      def display_stats
        puts "#{count} contract(s) retrieved from partner\n" \
             "#{found.size} contract(s) found in S3 bucket, " \
             "requiring #{count - found.size} correction(s)"
        puts '' if errors_total.zero?
        display_no_upload_required
        display_successful_upload
        puts ''
      end

      def display_errors
        puts "#{errors_total} error(s) were unable to be automatically corrected:"
        display_nil_id_errors
        display_dl_errors
        display_ul_errors
      end

      def display_no_upload_required
        return unless errors_total.zero? && count == found.size

        puts 'No missing contracts were found'
      end

      def display_successful_upload
        return unless errors_total.zero? && count != found.size

        puts "#{count - found.size} contract(s) successfully uploaded to S3 bucket"
      end

      def display_nil_id_errors
        return unless nil_id.positive?

        puts "#{nil_id} contract(s) contained no ID"
      end

      def display_dl_errors
        return unless dl_failed.count.positive?

        puts "#{dl_failed.size} contract(s) were unable to be downloaded from partner:"
        dl_failed.each do |id|
          puts id
        end
      end

      def display_ul_errors
        return unless ul_failed.count.positive?

        puts "#{ul_failed.size} contract(s) were unable to be uploaded to S3 bucket:"
        ul_failed.each do |id|
          puts id
        end
      end
    end
  end
end
