# frozen_string_literal: true

namespace :applications do
  desc 'Cancels open contract applications'
  task cancel: :environment do
    Wellness::BatchCancelApplicationsJob.perform_now
  end
end
