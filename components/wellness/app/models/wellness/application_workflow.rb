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

    def partner_initialization_request(request)
      request = JSON.parse(translate(request))
      request['location'] = { id: request['externalLocationCd'] }
      request['plan'] = { id: request['externalPlanCd'] }
      request['portalUsername'] = request['email'] if request['portalUsername'].blank?
      request['status'] = 20
      request.to_json
    end

    def partner_finalization_request(request)
      request = JSON.parse(translate(request, skip_defaults: true))
      request['status'] = 5
      request.to_json
    end

    def translate(request, skip_defaults: false)
      RequestTranslation.new(request,
                             skip_defaults).translate_request.to_json
    end
  end
end
