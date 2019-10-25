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

  end
end
