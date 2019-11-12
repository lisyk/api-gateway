# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.swagger_root = Rails.root.join('swagger/vip-api-docs').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under swagger_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a swagger_doc tag to the
  # the root example_group in your specs, e.g. describe '...', swagger_doc: 'v2/swagger.json'
  config.swagger_docs = {
    'wellness/v1/swagger.json' => {
      openapi: '3.0.0',
      info: {
        title: 'VIP API Gateway',
        version: 'v1',
        description: 'VIP API Gateway Documentation'
      },
      basePath: '/',
      components: {
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearerFormat: 'JWT'
          }
        },
        schemas: {
          plan_list: {
            type: :object,
            properties: {
              plans: { type: :array, items: { '$ref' => '#components/schemas/wellness_plan' } }
            }
          },
          wellness_plan: {
            type: :object,
            properties: {
              id: { type: :integer },
              ageGroup: { type: :integer },
              autoRenew: { type: :boolean },
              dateCreated: { type: :string },
              displayOrder: { type: :integer },
              externalPlanCd: { type: :string },
              lastUpdated: { type: :string },
              location: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  accountCd: { type: :string },
                  address1: { type: :string },
                  address2: { type: :string },
                  city: { type: :string },
                  country: { type: :string },
                  externalLocationCd: { type: :string },
                  name: { type: :string },
                  postalCode: { type: :string },
                  resellerCustomerId: { type: :integer },
                  state: { type: :string }
                },
                required: ['id', 'accountCd', 'address1', 'address2', 'city', 'country', 'externalLocationCd', 'name', 'postalCode', 'resellerCustomerId', 'state']
              },
              locationId: { type: :integer },
              longDescription: { type: :string },
              paidInFullDiscountAmt: { type: :integer },
              paymentTerm: { type: :integer },
              planAmount: { type: :number },
              planEffectiveDate: { type: :string },
              planExpirationDate: { type: :string },
              planServices: {
                type: :array,
                items: []
              },
              planStatus: { type: :string },
              planType: { type: :integer },
              productSubType: { type: :string },
              recurringPaymentAmt: { type: :number },
              renewalPlan: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  ageGroup: { type: :integer },
                  autoRenew: { type: :boolean },
                  dateCreated: { type: :string },
                  displayOrder: { type: :integer },
                  externalPlanCd: { type: :string },
                  lastUpdated: { type: :string },
                  location: {
                    type: :object,
                    properties: {
                      id: { type: :integer },
                      accountCd: { type: :string },
                      address1: { type: :string },
                      address2: { type: :string },
                      city: { type: :string },
                      country: { type: :string },
                      externalLocationCd: { type: :string },
                      name: { type: :string },
                      postalCode: { type: :string },
                      resellerCustomerId: { type: :integer },
                      state: { type: :string }
                    },
                    required: ['id', 'accountCd', 'address1', 'address2', 'city', 'country', 'externalLocationCd', 'name', 'postalCode', 'resellerCustomerId', 'state']
                  },
                  locationId: { type: :integer },
                  longDescription: { type: :string },
                  paidInFullDiscountAmt: { type: :integer },
                  paymentTerm: { type: :integer },
                  planAmount: { type: :number },
                  planEffectiveDate: { type: :string },
                  planExpirationDate: { type: :string },
                  planServices: {
                    type: :array,
                    items: [{
                      type: :object,
                      properties: {
                        id: { type: :integer },
                        offeredService: {
                          type: :object,
                          properties: {
                            id: { type: :integer },
                            shortDescription: { type: :string }
                          },
                          required: ['id', 'shortDescription']
                        },
                        plan: {
                          type: :object,
                          properties: {
                            id: { type: :integer },
                            shortDescription: { type: :string }
                          },
                          required: ['id', 'shortDescription']
                        },
                        cost: { type: :number, nullable: true },
                        dateCreated: { type: :string },
                        discountPercent: { type: :integer, nullable: true },
                        discountedPrice: { type: :number },
                        displayOrder: { type: :integer },
                        doNotRenew: { type: :boolean },
                        externalPlanCd: { type: :string, nullable: true },
                        astUpdated: { type: :string },
                        offeredServiceId: { type: :integer },
                        performancePayPrice: { type: :number, nullable: true },
                        planEffectiveDate: { type: :string },
                        planExpirationDate: { type: :string },
                        planId: { type: :integer },
                        quantity: { type: :integer },
                        retailPrice: { type: :integer },
                        revenuePerUnit: { type: :number },
                        serviceType: { type: :string },
                        totalDiscountedPrice: { type: :number },
                        totalRevenue: { type: :number },
                        totalTrueCost: { type: :null }
                      },
                      required: [
                        'id', 'offeredService', 'plan', 'cost', 'dateCreated', 'offeredServiceId', 'planId', 'quantity',
                        'retailPrice', 'serviceType'
                      ]
                    }]
                  },
                  planStatus: { type: :string },
                  planType: { type: :integer },
                  productSubType: { type: :string },
                  recurringPaymentAmt: { type: :number },
                  renewalPlan: {
                    type: :object,
                    properties: {
                      _ref: { type: :string },
                      class: { type: :string }
                    }
                  },
                  renewalPlanId: { type: :integer },
                  shortDescription: { type: :string },
                  species: { type: :integer },
                  vip_mapped_attributes: {
                    type: :object,
                    properties: {
                      species: { type: :integer },
                      age_group: { type: :integer, nullable: true },
                      sex: { type: :string, nullable: true }
                    }
                  }
                }
              },
              required: ['id', 'ageGroup', 'autoRenew', 'locationId', 'longDescription', 'planStatus']
            }
          },
          contract_application_list: {
            type: :object,
            properties: {
              items: { type: :array, items: { '$ref' => '../jsonschemas/vcp/contract_application.json' } }
            }
          },
          contract_application: {
            type: :object,
            properties: {
              id: { type: :integer, nullable: true },
              validatedFieldList: {
                type: :array,
                items: {
                  properties: {
                    validatedFieldList: { type: :string }
                  }
                }
              },
              location: {
                type: :object,
                items: {
                  properties: {
                    id: { type: :integer }
                  }
                }
              },
              plan: {
                type: :object,
                items: {
                  properties: {
                    id: { type: :integer }
                  }
                }
              },
              externalLocationCd: { type: :integer, nullable: true },
              externalPlanCd: { type: :integer, nullable: true },
              salutation: { type: :string },
              firstName: { type: :string },
              middleInitial: { type: :string, nullable: true },
              lastName: { type: :string },
              address1: { type: :string },
              address2: { type: :string, nullable: true },
              city: { type: :string },
              state: { type: :string },
              postalCode: { type: :string },
              country: { type: :string },
              phone1: { type: :string },
              phone1Type: { type: :string },
              phone2: { type: :string },
              phone2Type: { type: :string },
              email: { type: :string },
              portalUsername: { type: :string },
              externalClientCd: { type: :string, nullable: true },
              externalMemberCd: { type: :string, nullable: true },
              memberName: { type: :string },
              memberAge: { type: :string },
              gender: { type: :string, nullable: true },
              initiatedByProfessional: {
                type: :array,
                nullable: true,
                properties: {
                  id: { type: :integer, nullable: true }
                }
              },
              primaryCareProfessional: {
                type: :array,
                nullable: true,
                properties: {
                  id: { type: :integer, nullable: true }
                }
              },
              initiatedByProfessionalCd: { type: :integer, nullable: true },
              primaryCareProfessionalCd: { type: :integer, nullable: true },
              payOption: { type: :string, nullable: true },
              payMethod: { type: :string, nullable: true },
              paymentName: { type: :string },
              accountNbrForDisplay: { type: :string },
              accountNbr: { type: :integer },
              institutionName: { type: :string },
              bankAccountHolderType: { type: :string },
              bankAccountType: { type: :string },
              bankRoutingNbr: { type: :string },
              paymentaddressSameAsAccount: { type: :boolean },
              expirationMonth: { type: :integer, nullable: true },
              expirationYear: { type: :integer, nullable: true },
              securityCode: { type: :integer, nullable: true },
              externalPaymentProfileId: { type: :string },
              optionalPlanServices: {
                type: :array,
                planService: {
                  type: :object,
                  properties: {
                    id: { type: :integer }
                  }
                }
              }
            }
          },
          service_list: {
            type: :object,
            properties: {
              plans: { type: :array, items: { '$ref' => '#components/schemas/plan_services' } }
            }
          },
          plan_services: {
            type: :object,
            properties: {
              id: { type: :integer },
              offeredService: {
                type: :object,
                properties: {
                  id: { type: :integer },
                  shortDescription: { type: :string }
                }
              },
              plan: {
                type: :object,
                properties: {
                  id: { type: :integer, nullable: true }
                }
              },
              cost: { type: :number, nullable: true },
              dateCreated: { type: :string },
              discountPercent: { type: :number, nullable: true },
              discountedPrice: { type: :number },
              displayOrder: { type: :integer },
              doNotRenew: { type: :boolean },
              externalPlanCd: { type: :integer, nullable: true },
              lastUpdated: { type: :string },
              offeredServiceId: { type: :integer },
              performancePayPrice: { type: :number, nullable: true },
              planEffectiveDate: { type: :string },
              planExpirationDate: { type: :string },
              planId: { type: :integer },

              quantity: { type: :integer },
              retailPrice: { type: :number },
              revenuePerUnit: { type: :number },
              serviceType: { type: :string },
              totalDiscountedPrice: { type: :number },
              totalRevenue: { type: :number, nullable: true },
              totalTrueCost: { type: :number, nullable: true }
            }
          }
        }
      }
    },
    paths: {},
    servers: [
      {
        url: 'http://{defaultHost}',
        variables: {
          defaultHost: { default: 'localhost:3111/' }
        }
      }
    ]
  }
end
