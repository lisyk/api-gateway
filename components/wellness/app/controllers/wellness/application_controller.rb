# frozen_string_literal: true

require 'json-schema'

module Wellness
  class ApplicationController < ::Api::V1::ApiController
    # protect_from_forgery with: :exception
    before_action :user_authorized?
    before_action :convert_url_pet_id

    def convert_url_pet_id
      return if params[:id].blank?

      pet_regex = /[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/
      pet_id_matches = params[:id].match(pet_regex)
      return unless pet_id_matches

      pet_id = pet_id_matches[0]
      response = contract_app_id_client(pet_id).get
      return unless response

      params[:id] = contract_app_id(response) if contract_app_id(response).present?
    end

    private

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def contract_app_id_client(pet_id)
      client = Connect.new
      url = client.url + '/contractApplication'
      Faraday.new(url: url, params: { 'externalMemberCd' => pet_id }) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers['Authorization'] = "Bearer #{client.token}" if client.token.present?
      end
    end

    def contract_app_id(response)
      JSON.parse(response.body).first.fetch('externalMemberCd')
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
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
      RequestTranslation.new(request).translate_request.to_json
    end

    def schema
      { '$ref' => json_schema_path + fragment }
    end

    def fragment
      "#/components/schemas/#{controller_name}_#{action_name}"
    end
  end
end
