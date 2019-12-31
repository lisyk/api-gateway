# frozen_string_literal: true

module Wellness
  class ApplicationWorkflow < Connect
    def validate_submission(response)
      response.present? &&
        response.include?('id') &&
        response.include?('externalMemberCd') &&
        response['errors'].blank?
    end
  end
end
