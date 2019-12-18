# frozen_string_literal: true

module Wellness
  class ApplicationController < ::Api::V1::ApiController
    # protect_from_forgery with: :exception
    before_action :user_authorized?

    private

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end

    def json_schema_engine_path
      "#{controller_name}.json"
    end

    def validate_request
      fragment = "##{controller_name}_#{action_name}"
      schema = { '$ref' => json_schema_path + json_schema_engine_path + fragment }
      validation_errors = JSON::Validator.fully_validate(schema,
                                                         request.body.read,
                                                         errors_as_objects: true)

      return if validation_errors.blank?

      render json: { malformed_request: validation_errors },
             status: :bad_request
    end

    def contract_app_id
      JSON.parse(response.body)['id']
    end

    def pet_id
      JSON.parse(response.body)['externalMemberCd']
    end

    def retain_id_link
      DbEngineInteractor.call(pet_id: pet_id, contract_app_id: contract_app_id)
    end
  end
end
