# frozen_string_literal: true

module Wellness
  module Concerns
    module RequestConcern
      attr_reader :controller, :action, :params

      def initialize(controller, action, params = {})
        @controller = controller
        @action = action
        @params = params
        super()
      end

      def api_request
        response = client.send(request_method, request_resource)
        parse_response(response) if response
      end

      def api_post(body)
        response = client.post(request_resource, body, "Content-Type" => "application/json")
        parse_response(response) if response
      end

      private

      def parse_response(response)
        if response.headers['content-type'].include?('application/json')
          response = JSON.parse(response.body)
        end
        response
      end

      def request_mapper
        path = File.expand_path('config/client_endpoints/endpoints.yml', Wellness::Engine.root)
        file = File.read(path)
        mapper = YAML.safe_load(file)
        mapper[controller][action]
      end

      def request_resource
        resource = request_mapper['resource']
        resource += "/#{params[:id]}" if params[:id].present?
        resource
      end

      def request_method
        request_mapper['method']
      end
    end
  end
end
