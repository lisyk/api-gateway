# frozen_string_literal: true

module Wellness
  class BatchCancelApplicationsJob < ApplicationJob
    attr_reader :status

    queue_as :default

    def perform(status = nil, last_updated_before_date = nil)
      start_job_message
      last_updated_before_date ||= DateTime.current #- 8.days
      @last_updated_before_date = last_updated_before_date.strftime('%Y-%m-%d')
      @status = status.nil? ? [] : status.map(&:to_s)
      @status = { success: 0, errors: [] }
      response = fetch_open_applications
      applications = JSON.parse(response.body)
      puts "Retrieved #{applications.count} records from partner. Attempting to cancel..."
      cancel_applications(applications)
      finish_job_message
      display_results
    end

    private

    def connection
      Wellness::Connect.new
    end

    def fetch_open_applications
      connection.client.send(:get, contract_application_index_url)
    end

    def cancel_applications(applications)
      applications.each do |application|
        id = application['id']
        status = application['status']

        cancel_application(id, status)
      end
    end

    def contract_application_index_url
      'contractApplication.json?thruDate=' + @last_updated_before_date
    end

    def contract_application_update_url(id)
      'contractApplication/' + id.to_s
    end

    def cancellation_params
      { 'status' => '7' }
    end

    def cancel_application(id, status)
      return if %w[0 5 7].include?(status) || (@status.any? && !@status.include?(status))

      print "#{DateTime.current}: Canceling application ID##{id}... "
      response = connection.client.send(:put,
                                        contract_application_update_url(id),
                                        cancellation_params)

      check_cancellation(response, id)
    end

    def check_cancellation(response, id)
      if response.status == 200
        @status[:success] += 1
        puts 'Success'
      else
        @status[:errors] << id
        puts 'Failed: response status ' + response.status.to_s
      end
    end

    def start_job_message
      puts '*' * 10 + ' Starting job... ' + '*' * 10
    end

    def finish_job_message
      puts '*' * 13 + ' Finished! ' + '*' * 13
    end

    def display_results
      puts ''
      success_message
      errors_message if @status[:errors].size.positive?
      puts ''
    end

    def success_message
      if @status[:success].zero? && @status[:errors].empty?
        puts 'No corrections required.'
      else
        puts "#{@status[:success]} applications successfully canceled."
      end
    end

    def errors_message
      puts "#{@status[:errors].size} applications were unable to be automatically canceled:"
      @status[:errors].each { |id| puts id }
    end
  end
end
