# frozen_string_literal: true

module Wellness
  module Services
    module PetUuidService
      private

      def convert_pet_uuid
        return if params[:id].blank?

        pet_regex = /[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/
        pet_uuid_matches = params[:id].match(pet_regex)
        return unless pet_uuid_matches

        pet_uuid = pet_uuid_matches[0]
        response = contract_app_id_client(pet_uuid).get
        return unless response

        params[:id] = id(response) if id(response).present?
      end

      def contract_app_id_client(pet_uuid)
        query_params = { 'externalMemberCd' => pet_uuid }
        Connect.new('/contractApplication', query_params).client
      end

      def id(response)
        JSON.parse(response.body).first.fetch('id').to_s
      end
    end
  end
end
