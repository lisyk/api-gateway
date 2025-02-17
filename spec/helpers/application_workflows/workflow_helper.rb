# frozen_string_literal: true

class WorkflowHelper < ActionDispatch::IntegrationTest
  attr_reader :contract_id, :initial_response_body, :agreement_response_body

  def post_initial_request
    post '/api/v1/wellness/contract_applications',
         params: initial_request_body,
         headers: {
           Authorization: "Bearer #{token}",
           'Content-Type'.to_sym => 'application/json'
         }
    @initial_response_body = JSON.parse(response.body)
    @contract_id = @initial_response_body['id']
    response
  end

  def put_agreement
    put "/api/v1/wellness/contract_applications/agreements/#{@contract_id}",
        params: { document: agreement },
        headers: {
          Authorization: "Bearer #{token}",
          'Content-Type'.to_sym => 'application/pdf'
        }
    @agreement_response_body = JSON.parse(response.body)
    response
  end

  def rswag_initial_request_body
    JSON.parse(initial_request_body)
  end

  private

  def dummy_email
    first_name = random_string
    last_name = random_string
    provider = random_string
    domain = %w[com net edu org gov].sample
    first_name + '.' + last_name + '@' + provider + '.' + domain
  end

  def random_string
    SecureRandom.hex[0..9]
  end

  def initial_request_body
    initial_request_file = File.read(Rails.root.join('spec/helpers/dummy_docs/application_workflows/post_initiate_application.json'))
    payload = JSON.parse(initial_request_file)
    payload['pet_id'] = SecureRandom.uuid
    payload['owner_id'] = SecureRandom.uuid.to_s[0..15]
    payload['email'] = dummy_email
    payload['portalUsername'] = payload['email']
    payload.to_json
  end

  def agreement
    Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/contract.pdf'))
  end

  def token
    post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
    JSON.parse(response.body)['token']
  end
end
