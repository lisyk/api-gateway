# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    before_action :validate_request, only: :update

    def update
      translated_request = build_partner_finalization_request(request)
      @contract ||= put_apps(translated_request)
      if @contract.present? && @contract['errors'].blank? && contract_completed
        render json: @contract
      else
        render_not_completed
      end
    end

    private

    def build_partner_finalization_request(request)
      request = JSON.parse(translate(request, skip_defaults: true))
      request['status'] = 5
      request.to_json
    end

    def put_apps(request)
      workflow = ContractApplication.new('contract_applications', 'update', params)
      response = workflow.api_put(request)
      workflow.contract_app_mapping({}, response)
    end

    def render_errors(response)
      if response && response['errors'].present?
        render json: { errors: response['errors'] },
               status: :bad_request
      else
        render json: { errors: ['No response returned'] },
               status: :unprocessable_entity
      end
    end

    def translate(request, skip_defaults: false)
      RequestTranslation.new(request, controller_name, skip_defaults).translate_request.to_json
    end

    def contract_completed
      @contract['status'].present? && @contract['status'].to_i == 5
    end

    def render_not_completed
      render json: {
        errors: ['Contract application was not completed by provider.'],
        response: @contract
      },
             status: :unprocessable_entity
    end
  end
end
