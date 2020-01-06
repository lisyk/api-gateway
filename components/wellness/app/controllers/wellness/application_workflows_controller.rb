# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    before_action :validate_request, only: :create

    def create
      prepared_request = build_partner_request(request)
      @response ||= post_contract(prepared_request)
      if valid_submission?(@response)
        retain_id_link
        @contract_document ||= retrieve_agreement(contract_id)
        render_agreement(@contract_document, contract_id)
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
      workflow.validate_submission(response)
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

    def contract_id
      @response['id']
    end

    def pet_id
      @response['externalMemberCd']
    end

    def retain_id_link
      DbEngineInteractor.call(pet_id: pet_id, contract_app_id: contract_id)
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
