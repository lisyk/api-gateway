# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    before_action :validate_request, only: :update

    def update
      translated_request = translate(request)
      @contract ||= put_apps(translated_request)
      if @contract.present? && @contract['errors'].blank?
        render json: @contract,
               status: :created
      else
        render_errors(@contract)
      end
    end

    private

    def put_apps(request)
      workflow = ContractApplication.new('contract_applications', 'update', params)
      workflow.api_put(request)
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

    def translate(request)
      RequestTranslation.new(request, controller_name).translate_request.to_json
    end
  end
end
