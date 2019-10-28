# frozen_string_literal: true

require_dependency 'wellness/application_controller'

module Wellness
  class ContractApplicationsController < ::Api::V1::ApiController
    before_action :user_authorized?

    def index
      @applications ||= demo_client_ready ? client_request : test_applications
      render json: @applications
    end

    def show
      response = demo_client_ready ? client_request(application_params) : test_application
      @application ||= response
      render json: @application
    end

    def create
      response = demo_client_ready ? client_post_request : test_post_application
      @application ||= response
      render json: @application
    end

    private

    # test hardcoded data. TODO clean up
    def test_applications
      { applications: [
        {
          "id": '123',
          "name": 'application',
          "age": '13'
        },
        {
          "id": '1234',
          "name": 'application2',
          "age": '2'
        }
      ] }
    end

    def test_application
      {
        "id": '123',
        "name": 'application',
        "age": '13'
      }
    end

    def test_post_application
      {
        "validatedFieldList": [
          'validateAll'
        ],
        "location": {
          "id": 5_426_720
        },
        "plan": {
          "id": 5_428_455
        },
        "externalLocationCd": '',
        "externalPlanCd": '',
        "salutation": 'Mr.',
        "firstName": 'Olivia',
        "middleInitial": '',
        "lastName": 'Wright',
        "address1": '100 Argonaut',
        "address2": '',
        "city": 'Morino Valley',
        "state": 'CA',
        "postalCode": '92551',
        "country": 'US',
        "phone1": '9494814601',
        "phone1Type": 'H',
        "phone2": '9494814602',
        "phone2Type": 'W',
        "email": 'Olivia.Wright@ExtendCredit.com',
        "portalUsername": 'test1234@test.com',
        "externalClientCd": '1000',
        "externalMemberCd": '1',
        "memberName": 'Cece',
        "memberAge": '1Y 2M',
        "gender": '',
        "initiatedByProfessional": {
          "id": nil
        },
        "primaryCareProfessional": {
          "id": nil
        },
        "initiatedByProfessionalCd": '',
        "primaryCareProfessionalCd": '',
        "payOption": 'ACH',
        "payMethod": 'ACH',
        "paymentName": 'Olivia Wright',
        "accountNbrForDisplay": '5354',
        "accountNbr": '1376025354',
        "institutionName": 'UNION BANK',
        "bankAccountHolderType": 'P',
        "bankAccountType": 'C',
        "bankRoutingNbr": '122000496',
        "paymentaddressSameAsAccount": true,
        "expirationMonth": nil,
        "expirationYear": nil,
        "securityCode": '',
        "externalPaymentProfileId": '',
        "optionalPlanServices": []
      }
    end

    def client_request(params = {})
      WellnessPlans.new.api_request(controller_name, action_name, params)
    end

    def client_post_request
      response = JSON.parse(request.body.read)
      WellnessPlans.new.api_post_request(controller_name, response)
    end

    def user_authorized?
      return unless @current_user != 'authorized'

      render json: { errors: ['You are not authorized'] }, status: :forbidden
    end

    def demo_client_ready
      Settings.api.vcp_wellness.demo_client_ready
    end

    def application_params
      params.except(:format).permit(:id)
    end
  end
end
