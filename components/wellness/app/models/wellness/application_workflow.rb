# frozen_string_literal: true

module Wellness
  class ApplicationWorkflow < Connect
    include Concerns::RequestConcern

    def validate_submission(response)
      response.include?('id') &&
        response.include?('externalMemberCd') &&
        response['errors'].blank?
    end
  end
end
