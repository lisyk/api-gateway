# frozen_string_literal: true

module Wellness
  class ContractApplicationsController < Wellness::ApplicationController
    def index
      # TODO: needs to be updated from DEMO to PROD
      @applications ||= contract_apps if demo_client_ready
      if @applications.present?
        render json: @applications
      else
        render json: { errors: ['Contract applications agreements are not available.'] },
               status: :not_found
      end
    end

    def show
      # TODO: needs to be updated from DEMO to PROD
      @application ||= contract_apps(application_params) if demo_client_ready
      if @application.present?
        render json: @application
      else
        render json: { errors: ['Contract application agreement is not found'] },
               status: :not_found
      end
    end

    def create
      response = demo_client_ready ? client_post_request : test_post_application
      @application ||= response
      if @application
        render json: @application
      else
        render json: { errors: ['Application was not created.'] }, status: :unprocessable_entity
      end
    end

    private

<<<<<<< HEAD
    def contract_apps(params = {})
      contract_app = ContractApplication.new(controller_name, action_name, params)
      contract_app.api_request
=======
    # test hardcoded data. TODO clean up
    def test_applications
      { applications: [
        {
          "id": '123',
          "name": 'application',
          "age": '13'
        },
        {
          "id": '1234',
          "name": 'application2',
          "age": '2'
        }
      ] }
    end

    def test_application
      {
        "id": '123',
        "name": 'application',
        "age": '13'
      }
    end

    def test_post_application
      sample_application =
        File.read(
          File.expand_path(
            Wellness::Engine.root.join('app', 'models', 'application_schema.json')
          )
        )
      JSON.parse(sample_application)
    end

    def client_request(params = {})
      WellnessPlans.new.api_request(controller_name, action_name, params)
>>>>>>> Include dummy data helpers
    end

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
