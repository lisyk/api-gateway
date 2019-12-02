# frozen_string_literal: true

module Wellness
  class ContractApplicationsController < Wellness::ApplicationController
    after_action :retain_id_link, only: :create
    before_action :pet_id, only: :create
    before_action :validate_request, only: %i[create update]

    def index
      @applications ||= contract_apps
      if @applications.present?
        render json: @applications
      else
        render json: { errors: ['Contract applications agreements are not available.'] },
               status: :not_found
      end
    end

    def show
      @application ||= contract_apps(application_params)
      if @application.present?
        render json: @application
      else
        render json: { errors: ['Contract application agreement is not found.'] },
               status: :not_found
      end
    end

    def create
      @request ||= post_apps(request)
      if @request.present?
        render json: @request
      else
        render json: { errors: ['Contract application was not created.'] },
               status: :unprocessable_entity
      end
    end

    def update
      @request ||= put_apps(request)
      if @request.present?
        render json: @request
      else
        render json: { errors: ['Contract application was not updated.'] },
               status: :unprocessable_entity
      end
    end

    private

    def contract_apps(params = {})
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_request
    end

    def retain_id_link
      DbEngineInteractor.call(pet_id: @pet_id, contract_app_id: contract_app_id)
    end

    def contract_app_id
      JSON.parse(response.body)['id']
    end

    def pet_id
      @pet_id = params['pet']['id']
    end

    def post_apps(request)
      body = JSON.parse(request.body.read)
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_post(body.to_json)
    end

    def put_apps(request)
      body = JSON.parse(request.body.read)
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_put(body.to_json)
    end

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
