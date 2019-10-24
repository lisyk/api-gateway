# frozen_string_literal: true

module Wellness
  class ApplicationController < ::Api::V1::ApiController
    # protect_from_forgery with: :exception

    private

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end

    def client_request(params = {})
      WellnessPlans.new.api_request(controller_name, action_name, params)
    end
  end
end
