# frozen_string_literal: true

module Wellness
  class AgreementsController < Wellness::ApplicationController
    include Services::AwsS3Service

    def show
      @agreement ||= fetch_agreement(agreement_params)
      if @agreement.present?
        send_data @agreement.body, filename: "#{agreement_params[:id]}.pdf"
      else
        render json: { errors: ['Agreement unavailable.'] }, status: :not_found
      end
    end

    def update
      @response ||= put_agreement(agreement_params) || {}
      parsed_response = Agreement.build_client_response(@response)
      parsed_response[:messages][:id] = agreement_id if agreement_id.present?
      render_messages(parsed_response) && return if parsed_response[:messages][:errors].present?
      messages = store_agreement(parsed_response)
      render_messages(messages)
    end

    def create
      @response = store_agreement
      render_messages(@response)
    end

    private

    def fetch_agreement(params = {})
      agreement = Agreement.new(controller_name, action_name, params)
      agreement.api_request
    end

    def put_agreement(params = {})
      return { 'errors' => ['No file attached'] } unless params[:document].respond_to?(:tempfile)

      body = {
        id: params[:id],
        documentFileBase64: Base64.strict_encode64(File.read(params[:document].tempfile))
      }
      agreement = Agreement.new(controller_name, action_name, params)
      agreement.api_put(body, headers)
    end

    def render_messages(messages:, status:)
      render json: messages,
             status: status
    end

    def document
      return nil unless params[:document].respond_to?(:tempfile)

      Base64.strict_encode64(File.read(params[:document].tempfile))
    end

    def agreement_id
      return nil if params[:id].blank?

      params[:id]
    end

    def agreement_params
      params.except(:format).permit(:id, :document)
    end
  end
end
