# frozen_string_literal: true

module Wellness
  class ApplicationWorkflow < Connect
    def validate_finalization_request(request)
      request.present? &&
        request.include?('status') &&
        request['status'].to_s == '5' &&
        request['errors'].blank?
    end

    def validate_initialization_response(response)
      response.present? &&
        response.include?('id') &&
        response.include?('externalMemberCd') &&
        response['errors'].blank?
    end
  end
end
