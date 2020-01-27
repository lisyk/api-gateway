# frozen_string_literal: true

# this model is responsible for Agreements
# no other services handled by this model

module Wellness
  class Agreement < Connect
    include Concerns::RequestConcern

    def self.build_client_response(response)
      if response.present? && response['errors'].nil?
        status = :ok
        message = { success: ['Signed agreement posted successfully.'], status: status }
      elsif response.empty?
        status = :not_found
        message = { errors: ['Agreement not found.'], status: status }
      else
        response['errors'] ||= ['Agreement failed to update.']
        status = :unprocessable_entity
        message = { errors: response['errors'], status: status }
      end
      { messages: message, status: status }
    end
  end
end
