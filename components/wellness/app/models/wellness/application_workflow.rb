# frozen_string_literal: true

module Wellness
  class ApplicationWorkflow < Connect
    def validate_finalization_request(request)
      request.present? &&
        request.include?('initialPaymentOption') &&
        request.include?('accountNbr') &&
        request['errors'].blank?
    end
  end
end
