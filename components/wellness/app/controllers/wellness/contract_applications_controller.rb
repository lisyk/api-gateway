# frozen_string_literal: true

module Wellness
  class ContractApplicationsController < Wellness::ApplicationController
    after_action :retain_id_link, only: :create
    before_action :validate_request, only: %i[create update]

    def index
      @applications ||= contract_apps
      if @applications.present?
        render json: @applications
      else
        render json: { errors: ['Contract applications are not available.'] },
               status: :not_found
      end
    end

    def show
      @application ||= contract_apps(application_params)
      if @application.present?
        render json: @application
      else
        render json: { errors: ['Contract application is not found.'] },
               status: :not_found
      end
    end

    def create
      translated_request = translate(request)
      @response ||= post_apps(translated_request)
      if @response.is_a?(Hash) && @response.keys == ['errors']
        render json: @response,
               status: :bad_request
      elsif @response.present?
        render json: @response
      else
        render json: { errors: ['Contract application was not created.'] },
               status: :unprocessable_entity
      end
    end

    def update
      translated_request = translate(request)
      @response ||= put_apps(translated_request)
      if @response.is_a?(Hash) && @response.keys == ['errors']
        render json: @response,
               status: :bad_request
      elsif @response.present?
        render json: @response
      else
        render json: { errors: ['Contract application was not updated.'] },
               status: :unprocessable_entity
      end
    end

    private

    def contract_apps(params = {})
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.contract_app_mapping(params)
    end

    def post_apps(request)
      contract_app = ContractApplication.new(controller_name, action_name, params)
      response = contract_app.api_post(request)
      contract_app.contract_app_mapping({}, response)
    end

    def put_apps(request)
      contract_app = ContractApplication.new(controller_name, action_name, params)
      response = contract_app.api_put(request)
      contract_app.contract_app_mapping({}, response)
    end

    def application_params
      params.except(:format).permit(:id)
    end

    def retain_id_link
      DbEngineInteractor.call(pet_id: pet_id, contract_app_id: contract_app_id)
    rescue ActiveRecord::RecordInvalid
      @response = { errors: ['Could not store pet UUID, contract app ID link in integrator DB.'] }
    end

    def contract_app_id
      JSON.parse(response.body)['id'] if response.present?
    end

    def pet_id
      JSON.parse(response.body)['externalMemberCd'] if response.present?
    end
  end
end
