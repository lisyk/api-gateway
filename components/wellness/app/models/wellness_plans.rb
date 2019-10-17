# frozen_string_literal: true

require_dependency 'request_mapper'

class WellnessPlans < Connect
  def api_request(controller, action, params = {})
    endpoint = REQUEST_MAPPER[controller][action][:resource]
    method = REQUEST_MAPPER[controller][action][:method]
    resource = if params[:id].present?
                 endpoint + "/#{params[:id]}"
               else
                 endpoint
               end
    response = client.send(method, resource)
    parse_response(response)
  end

  def parse_response(response)
    if response.headers['content-type'].include?('application/json')
      response = JSON.parse(response.body)
    end
    response
  end
end
