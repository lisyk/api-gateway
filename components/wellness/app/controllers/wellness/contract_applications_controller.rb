# frozen_string_literal: true

module Wellness
  class ContractApplicationsController < Wellness::ApplicationController
    def index
      # TODO: needs to be updated from DEMO to PROD
      @applications ||= contract_apps if demo_client_ready
      if @applications.present?
        render json: @applications
      else
        render json: { errors: ['Contract applications agreements are not available.'] },
               status: :not_found
      end
    end

    def show
      # TODO: needs to be updated from DEMO to PROD
      @application ||= contract_apps(application_params) if demo_client_ready
      if @application.present?
        render json: @application
      else
        render json: { errors: ['Contract application agreement is not found'] },
               status: :not_found
      end
    end

    def create
      response = demo_client_ready ? client_post_request : test_post_application
      @application ||= response
      render json: @application
    end

    private

    def contract_apps(params = {})
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_request
    end

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
