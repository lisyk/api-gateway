# frozen_string_literal: true

module Wellness
  class ApplicationWorkflow < Connect
    def validate_finalization_request(request)
      request.present? &&
        request.include?('initialPaymentOption') &&
        request.include?('accountNbr') &&
        [1, 12].include?(request['accountNbr'].to_i) &&
        request['errors'].blank?
    end
  end
end
