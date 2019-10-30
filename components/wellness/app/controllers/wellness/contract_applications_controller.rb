# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ContractApplicationsController < ::Api::V1::ApiController
    before_action :user_authorized?

    def index
      @applications ||= demo_client_ready ? client_request : test_applications
      render json: @applications
    end

    def show
      response = demo_client_ready ? client_request(application_params) : test_application
      @application ||= response
      render json: @application
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
    end

    def client_post_request
      return nil if request.body.read.empty?

      response = JSON.parse(request.body.read)
      WellnessPlans.new.api_post_request(controller_name, response)
    end

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
