# frozen_string_literal: true

class WellnessPlans < Connect
  def api_request(controller, action, params = {})
    method_name = request_method(controller, action)
    resource_name = request_resource(controller, action, params)
    response = api_client.send(method_name, resource_name)
    parse_response(response)
  end

  private

  def parse_response(response)
    if response.headers['content-type'].include?('application/json')
      response = JSON.parse(response.body)
    end
    response
  end

  def request_mapper(controller, action)
    mapper = YAML.safe_load(
      File.read(
        File.expand_path('config/client_endpoints/endpoints.yml', Wellness::Engine.root)
      )
    )
    mapper[controller][action]
  end

  def request_resource(controller, action, params)
    resource = request_mapper(controller, action)['resource']
    resource += "/#{params[:id]}" if params[:id].present?
    resource
  end

  def request_method(controller, action)
    request_mapper(controller, action)['method']
  end
end
