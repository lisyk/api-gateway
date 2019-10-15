class WellnessPlans < Connect
  REQUEST_MAPPER = {'index' => {:method => 'get',
                                :resource => 'plans'}}.freeze

  def api_request(action)
    response = client.send(REQUEST_MAPPER[action][:method], REQUEST_MAPPER[action][:resource])
    JSON.parse(response.body)
  end
end