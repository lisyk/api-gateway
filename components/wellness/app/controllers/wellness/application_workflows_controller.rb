# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    before_action :validate_request, only: :create
    # after_action :retain_id_link, only: :create

    def create
      # render plain: 'success'
    end
  end
end
