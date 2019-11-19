# frozen_string_literal: true

require 'json-schema'

module Wellness
  class ContractApplicationsController < Wellness::ApplicationController
    before_action :validate_request, only: %i[create update]

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
        render json: { errors: ['Contract application agreement is not found.'] },
               status: :not_found
      end
    end

    def create
      # TODO: needs to be updated from DEMO to PROD
      @request ||= post_apps(request) if demo_client_ready
      if @request.present?
        render json: @request
      else
        render json: { errors: ['Contract application was not created.'] },
               status: :unprocessable_entity
      end
    end

    def update
      # TODO: needs to be updated from DEMO to PROD
      @request ||= put_apps(request) if demo_client_ready
      if @request.present?
        render json: @request
      else
        render json: { errors: ['Contract application was not updated.'] },
               status: :unprocessable_entity
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

    def put_apps(request)
      body = JSON.parse(request.body.read)
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_put(body.to_json)
    end

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
