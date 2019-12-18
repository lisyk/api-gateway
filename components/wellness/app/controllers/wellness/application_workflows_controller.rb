# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ApplicationWorkflowsController < Wellness::ApplicationController
    before_action :validate_request, only: :create

    def create
      prepared_request = build_partner_request(request)
      response ||= post_contract(prepared_request)
      if valid_submission?(response)
        # TODO: Implement UUID storage when VCP can accept UUID longer than 20 characters
        # retain_id_link(response)
        contract_document = retrieve_agreement(contract_id(response))
        render_agreement(contract_document, contract_id(response))
      else
        render_errors(response)
      end
    end

    private

    def build_partner_request(request)
      request = JSON.parse(translate(request))

      request['initialPaymentOption'] = 2 if request['initialPaymentOption'].blank?
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
      workflow = ApplicationWorkflow.new(controller_name, action_name, params)
      workflow.validate_submission(response)
    end

    def render_agreement(document, id)
      if document.present?
        send_data document.body, filename: "#{id}-agreement.pdf"
      else
        render json: { errors: ['Agreement unavailable.'] }, status: :not_found
      end
    end

    def render_errors(response)
      render json: { errors: [response['errors']] },
             status: :bad_request
    end

    def contract_id(response)
      response['id']
    end
  end
end
