# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ContractApplicationsController < ::Api::V1::ApiController
    before_action :user_authorized?

    def index
      #TODO needs to be updated from DEMO to PROD
      @applications ||= client_request if demo_client_ready
      if @applications.present?
        render json: @applications
      else
        render json: { errors: ['Contract applications agreements are not available.'] }, status: :not_found
      end
    end

    def show
      #TODO needs to be updated from DEMO to PROD
      @application ||= client_request(application_params) if demo_client_ready
      if @application.present?
        render json: @application
      else
        render json: { errors: ['Contract application agreement is nit found'] }, status: :not_found
      end

    end

    private

    def client_request(params = {})
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_request
    end

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
