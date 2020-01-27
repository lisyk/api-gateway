# frozen_string_literal: true

namespace :s3 do
  desc 'Validates presence of agreement document in S3 bucket, then ' \
       'attempts to fetch any missing documents and re-upload'
  task validate: :environment do
    Wellness::VerifyS3BucketJob.perform_now
  end
end
