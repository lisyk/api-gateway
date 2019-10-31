# frozen_string_literal: true

module Wellness
  class ContractApplication < Connect
    include Concerns::RequestConcern

    def post(request_body)
      resource_name = request_resource
      content_type = { 'Content-Type' => 'application/json' }
      response = client.post(resource_name, request_body.to_json, content_type)
      parse_response(response)
    end
  end
end
