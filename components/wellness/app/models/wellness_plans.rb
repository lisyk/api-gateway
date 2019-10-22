# frozen_string_literal: true

REQUEST_MAPPER = YAML.safe_load(
  File.read(
    File.expand_path('components/wellness/config/client_endpoints/endpoints.yml', Rails.root)
  )
)

class WellnessPlans < Connect
  def api_request(controller, action, params = {})
    endpoint = REQUEST_MAPPER[controller][action]['resource']
    method = REQUEST_MAPPER[controller][action]['method']
    resource = if params[:id].present?
                 endpoint + "/#{params[:id]}"
               else
                 endpoint
               end
    response = api_client.send(method, resource)
    parse_response(response)
  end

  def parse_response(response)
    if response.headers['content-type'].include?('application/json')
      response = JSON.parse(response.body)
    end
    response
  end
end
