# frozen_string_literal: true

module Api
  module V1
    class ApiController < ApplicationController
      before_action :set_default_format, :authenticate!

      private

      def set_default_format
        request.format = :json
      end

      def authenticate!
        payload = JwtAuthToken.decode(token)
        if payload.present?
          @current_user = 'authorized'
        end
      rescue JWT::DecodeError
        render json: { errors: ['Authentication token is not provided!'],
                       auth_status: :unauthorized },
               status: 403 if token.nil?
      rescue JWT::VerificationError
        render json: { errors: ['Authentication token is not valid!'],
                       auth_status: :unauthorized },
               status: 403
      rescue JWT::ExpiredSignature
        render json: { errors: ['Authentication token has expired.'],
                       auth_status: :expired },
               status: 403
      end

      def token
        @token ||= request.headers.fetch('Authorization', '').split(' ').last
      end
    end
  end
end