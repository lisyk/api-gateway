# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    before_action :validate_request, only: %i[create update]

    def update
      translated_request = application_workflow.partner_finalization_request(request)
      @contract ||= put_apps(translated_request)
      if @contract.present? && @contract['errors'].blank? && contract_completed
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

    def submit_agreement
      @response ||= put_agreement(agreement_params) || {}
      response_hash = store_agreement(build_client_response)
      render_messages(response_hash)
    end

    private

    def render_messages(messages:, status:)
      render json: messages,
             status: status
    end

    def store_agreement(message_hash)
      errors = true
      if errors && message_hash[:messages][:errors].present?
        message_hash[:messages][:errors] << 'Agreement not stored in S3 bucket.'
      else
        message_hash[:messages][:errors] = ['Agreement not stored in S3 bucket.']
      end
      message_hash
    end

    def build_client_response
      if @response.present? && @response['errors'].nil?
        message = { success: ['Signed agreement posted successfully.'] }
        status = :ok
      elsif @response.empty?
        message = { errors: ['Agreement not found.'] }
        status = :not_found
      else
        @response['errors'] ||= ['Agreement failed to update.']
        message = { errors: @response['errors'] }
        status = :unprocessable_entity
      end
      { messages: message, status: status }
    end

    def build_partner_request(request)
      request = JSON.parse(translate(request))
      request['location'] = { id: request['externalLocationCd'] }
      request['plan'] = { id: request['externalPlanCd'] }
      request['portalUsername'] = request['email'] if request['portalUsername'].blank?
      request['status'] = 20
      request.to_json
    end

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
      workflow = ApplicationWorkflow.new
      workflow.validate_initialization_response(response)
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

    def put_agreement(params = {})
      return { 'errors' => ['No file attached'] } unless params[:document].respond_to?(:tempfile)

      body = {
        id: params[:id],
        documentFileBase64: Base64.strict_encode64(File.read(params[:document].tempfile))
      }
      agreement = Agreement.new('agreements', 'update', params)
      agreement.api_put(body, headers)
    end

    def agreement_params
      params.except(:format).permit(:id, :document)
    end
  end
end
