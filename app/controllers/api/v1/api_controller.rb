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
        @current_user = 'authorized' if payload.present?
      rescue JWT::DecodeError
        if token.nil?
          render json: { errors: ['Authentication token is not provided!'],
                         auth_status: :unauthorized },
                 status: :forbidden
        end
      rescue JWT::VerificationError
        render json: { errors: ['Authentication token is not valid!'],
                       auth_status: :unauthorized },
               status: :forbidden
      rescue JWT::ExpiredSignature
        render json: { errors: ['Authentication token has expired.'],
                       auth_status: :expired },
               status: :forbidden
      end

      def token
        @token ||= request.headers.fetch('Authorization', '').split(' ').last
      end

      def json_schema_path
        Rails.root.join('swagger/vip-api-docs/wellness/v1/swagger.json').to_s
      end
    end
  end
end
