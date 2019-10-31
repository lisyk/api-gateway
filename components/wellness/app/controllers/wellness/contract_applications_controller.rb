# frozen_string_literal: true

module Wellness
  class ContractApplicationsController < Wellness::ApplicationController
    before_action :user_authorized?
    
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
      @request ||= post_apps(request) if demo_client_ready
      if @request
        render json: @request
      else
        render json: { errors: ['Contract application could not be submitted'] },
               status: :not_found
      end
    end

    private

    def contract_apps(params = {})
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_request
    end

    def post_apps(request)
      body = JSON.parse(request.body.read)
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_post(body.to_json)
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

    def post_params
      params.require(:contract_application)
    end
  end
end
