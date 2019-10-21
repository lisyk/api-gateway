# frozen_string_literal: true

module Api
  module V1
    class AuthenticationController < Api::V1::ApiController
      skip_before_action :authenticate!
      before_action :retrieve_credentials, :cred_params, :find_user

      def create
        if @user == 'api_client'
          render json: { token: JwtAuthToken.encode(user_role: 'vip_admin') }
        else
          render json: { errors: ['Invalid credentials.'] }, status: :forbidden
        end
      end

      private

      def retrieve_credentials
        @username = Rails.application.credentials.auth[Rails.env.to_sym][:user_name]
        @password = Rails.application.credentials.auth[Rails.env.to_sym][:password]
      end

      def find_user
        @user = 'api_client' if @username == params[:user_name] && @password == params[:password]
      end

      def cred_params
        params.require([:user_name, :password])
      rescue ActionController::ParameterMissing => e
        render json: { errors: [e.message.to_s] }
      end
    end
  end
end
