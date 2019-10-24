# frozen_string_literal: true

module Wellness
  class ContractApplicationsController < Wellness::ApplicationController
    before_action :user_authorized?

    def index
      @applications ||= demo_client_ready ? client_request : test_applications
      render json: @applications
    end

    def show
      request = demo_client_ready ? client_request(application_params) : test_application
      @application ||= request
      render json: @application
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

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
