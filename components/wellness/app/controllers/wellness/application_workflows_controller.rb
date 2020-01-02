# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    before_action :validate_request, only: %i[create update]

    def update
      translated_request = build_partner_finalization_request(request)
      @contract ||= put_apps(translated_request)
      if @contract.present? && @contract['errors'].blank? && contract_completed
        render json: @contract
      else
        render_not_completed
      end
    end

    def create
      prepared_request = build_partner_initialization_request(request)
      @response ||= post_contract(prepared_request)
      if valid_submission?(@response)
        retain_id_link
        @contract_document ||= retrieve_agreement(contract_app_id)
        render_agreement(@contract_document, contract_app_id)
      else
        render_errors(@response)
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

    def build_partner_initialization_request(request)
      request = JSON.parse(translate(request))
      request['location'] = { id: request['externalLocationCd'] }
      request['plan'] = { id: request['externalPlanCd'] }
      request['portalUsername'] = request['email'] if request['portalUsername'].blank?
      request['status'] = 20
      request.to_json
    end

    def post_contract(request)
      workflow = ContractApplication.new('contract_applications', 'create', params)
      workflow.api_post(request)
    end

    def retrieve_agreement(id)
      workflow = Agreement.new('agreements', 'show', id: id)
      workflow.api_request
    end

    def valid_submission?(response)
      workflow = ApplicationWorkflow.new
      workflow.validate_initialization_response(response)
    end

    def render_agreement(document, id)
      if document.present?
        send_data document.body, filename: "#{id}-agreement.pdf"
      else
        render json: { errors: ['Agreement not found.'] },
               status: :not_found
      end
    end

    def render_errors(response)
      if response && response['errors'].present?
        render json: { errors: [response['errors']] },
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

    def contract_app_id
      @response['id']
    end

    def pet_id
      @response['externalMemberCd']
    end

    def retain_id_link
      DbEngineInteractor.call(pet_id: pet_id, contract_app_id: contract_app_id)
    end
  end
end
