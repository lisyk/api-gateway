# frozen_string_literal: true

require 'json-schema'

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
      validation_errors = JSON::Validator.fully_validate(schema,
                                                         request.body.read,
                                                         errors_as_objects: true)

      return if validation_errors.blank?

      render json: { malformed_request: validation_errors },
             status: :bad_request
    end

    def translate(request)
      RequestTranslation.new(request, controller_name).translate_request.to_json
    end

    def schema
      fragment = "##{controller_name}_#{action_name}"
      { '$ref' => json_schema_path + json_schema_engine_path + fragment }
    end
  end
end
