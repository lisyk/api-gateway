# frozen_string_literal: true

require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<Authorization-REDACTED>') do |interaction|
    interaction.request.headers['Authorization'].try(:first)
  end
  c.filter_sensitive_data('<WELLNESS_VCP_PASSWORD>') { CGI.escape(ENV['WELLNESS_VCP_PASSWORD']) }
  c.filter_sensitive_data('<WELLNESS_VCP_USERNAME>') { CGI.escape(ENV['WELLNESS_VCP_USERNAME']) }
end
