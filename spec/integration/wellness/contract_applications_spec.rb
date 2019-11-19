# frozen_string_literal: true

require 'swagger_helper'
require './app/controllers/api/v1/authentication_controller.rb'

describe 'Wellness Plans API', swagger_doc: 'wellness/v1/swagger.json' do
  path '/api/v1/wellness/contract_applications' do
    post 'Create a new contract application' do
      tags 'Contract Applications'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :contract_application,
                in: :body,
                schema: {
                  '$ref' => '#/components/schemas/contract_application'
                }
      request_body_json schema: {
        '$ref' => '#/components/schemas/contract_application'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Create a new contract application' do
          schema '$ref' => '#/components/schemas/contract_application'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:contract_application) do
            {
              validatedFieldList: [
                'validateAll'
              ],
              location: {
                id: 5_426_720
              },
              plan: {
                id: 5_428_455
              },
              externalLocationCd: '',
              externalPlanCd: '',
              salutation: 'Mr.',
              firstName: 'Olivia',
              middleInitial: '',
              lastName: 'Wright',
              address1: '100 Argonaut',
              address2: '',
              city: 'Morino Valley',
              state: 'CA',
              postalCode: '92551',
              country: 'US',
              phone1: '9494814601',
              phone1Type: 'H',
              phone2: '9494814602',
              phone2Type: 'W',
              email: 'Olivia.Wright@ExtendCredit.com',
              portalUsername: 'test1234@test.com',
              externalClientCd: '1000',
              externalMemberCd: '1',
              memberName: 'Cece',
              memberAge: '1Y 2M',
              gender: '',
              initiatedByProfessional: {
                id: nil
              },
              primaryCareProfessional: {
                id: nil
              },
              initiatedByProfessionalCd: '',
              primaryCareProfessionalCd: '',
              payOption: 'ACH',
              payMethod: 'ACH',
              paymentName: 'Olivia Wright',
              accountNbrForDisplay: '5354',
              accountNbr: '1376025354',
              institutionName: 'UNION BANK',
              bankAccountHolderType: 'P',
              bankAccountType: 'C',
              bankRoutingNbr: '122000496',
              paymentaddressSameAsAccount: true,
              expirationMonth: nil,
              expirationYear: nil,
              securityCode: '',
              externalPaymentProfileId: '',
              optionalPlanServices: []
            }
          end
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/contract_applications' do
    get 'Retrieve a list of existing contract applications' do
      tags 'Contract Applications'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve list of contract applications' do
          schema '$ref' => '#/components/schemas/contract_application_list'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:contract_application) {}
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/contract_applications/{id}' do
    get 'Show a single contract application given an ID' do
      tags 'Contract Applications'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :id,
                in: :path,
                type: :string

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Retrieve list of contract applications' do
          schema '$ref' => '#/components/schemas/contract_application'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '1000013427' }
          let(:contract_application) {}
          run_test!
        end
      end
    end
  end

  path '/api/v1/wellness/contract_applications/{id}' do
    put 'Update an existing contract application. Used to modify fields and complete the application. Contract applications with a status of 5 are converted to finalized contracts.' do
      tags 'Contract Applications'
      produces 'application/json'
      consumes 'application/json'
      security [bearer_auth: []]
      parameter name: :contract_application,
                in: :body,
                schema: {
                  '$ref' => '#/components/schemas/contract_application'
                }
      parameter name: :id,
                in: :path,
                type: :string
      request_body_json schema: {
        '$ref' => '#/components/schemas/contract_application'
      }

      context 'Using valid credentials' do
        let(:token) do
          post '/api/v1/authentication', params: { user_name: 'test', password: 'test' }
          JSON.parse(response.body)['token']
        end

        response '200', 'Update an existing contract application' do
          schema '$ref' => '#/components/schemas/contract_application'
          let(:Authorization) { " Authorization: Bearer #{token} " }
          let(:id) { '1000013302' }
          let(:contract_application) do
            {
              validatedFieldList: [
                'validateAll'
              ],
              location: {
                id: 5_426_720
              },
              plan: {
                id: 5_428_455
              },
              externalLocationCd: '',
              externalPlanCd: '',
              salutation: 'Mr.',
              firstName: 'Olivia',
              middleInitial: '',
              lastName: 'Wright',
              address1: '100 Argonaut',
              address2: '',
              city: 'Morino Valley',
              state: 'CA',
              postalCode: '92551',
              country: 'US',
              phone1: '9494814601',
              phone1Type: 'H',
              phone2: '9494814602',
              phone2Type: 'W',
              email: 'Olivia.Wright@ExtendCredit.com',
              portalUsername: 'test1234@test.com',
              externalClientCd: '1000',
              externalMemberCd: '1',
              memberName: 'Cece',
              memberAge: '1Y 2M',
              gender: '',
              initiatedByProfessional: {
                id: nil
              },
              primaryCareProfessional: {
                id: nil
              },
              initiatedByProfessionalCd: '',
              primaryCareProfessionalCd: '',
              payOption: 'ACH',
              payMethod: 'ACH',
              paymentName: 'Olivia Wright',
              accountNbrForDisplay: '5354',
              accountNbr: '1376025354',
              institutionName: 'UNION BANK',
              bankAccountHolderType: 'P',
              bankAccountType: 'C',
              bankRoutingNbr: '122000496',
              paymentaddressSameAsAccount: true,
              expirationMonth: nil,
              expirationYear: nil,
              securityCode: '',
              externalPaymentProfileId: '',
              optionalPlanServices: [],
              firstBillingDate: "#{Date.current}T23:59:59Z"
            }
          end
          run_test!
        end
      end
    end
  end
end
