# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    include Services::PetUuidService

    before_action :validate_request, only: %i[create update]
    before_action :convert_pet_uuid, only: %i[update]

    def update
      translated_request = application_workflow.partner_finalization_request(request)
      @contract ||= put_apps(translated_request)
      if @contract.present? && @contract['errors'].blank? && contract_completed?
        render json: @contract
      else
        render_not_completed
      end
    end

    def create
      prepared_request = application_workflow.partner_initialization_request(request)
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

    def put_apps(request)
      workflow = ContractApplication.new('contract_applications', 'update', params)
      response = workflow.api_put(request)
      workflow.contract_app_mapping({}, response)
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
      application_workflow.validate_initialization_response(response)
    end

    def render_agreement(document, id)
      if document.present?
        render json: {
          contract_application_id: id,
          info_messages: ['Please download agreement and return via PUT /submit_agreement/:id'],
          agreement_document_base_64: Base64.strict_encode64(document.body)
        }
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

    def application_workflow
      ApplicationWorkflow.new
    end

    def contract_completed?
      @contract['status'].present? && @contract['status'].to_i == 5
    end

    def render_not_completed
      render json: { errors: ['Contract application was not completed by provider.'],
                     response: @contract },
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

    def agreement_params
      params.except(:format).permit(:id, :document)
    end
  end
end
