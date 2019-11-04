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
        }
      },
      definitions: {
        plan: {
          type: :object,
          properties: {
            id: { type: :integer },
            version: { type: :integer },
            ageGroup: { type: :integer },
            autoRenew: { type: :boolean },
            dateCreated: { type: :string },
            displayOrder: { type: :integer },
            externalPlanCd: { type: :string },
            lastUpdated: { type: :string },
            longDescription: { type: :string },
            paidInFullDiscountAmt: { type: :number },
            paymentTerm: { type: :integer },
            planAmount: { type: :number },
            planEffectiveDate: { type: :string },
            planExpirationDate: { type: :string },
            planServices: {
              type: :array,
              items: {
                properties: {
                  id: { type: :integer },
                  offeredService: {
                    type: :array,
                    items: {
                      properties: {
                        id: { type: :integer },
                        shortDescription: { type: :string }
                      }
                    }
                  },
                  plan: {
                    type: :array,
                    items: {
                      properties: {
                        id: { type: :integer },
                        shortDescription: { type: :string }
                      }
                    }
                  },
                  cost: { type: :number },
                  dateCreated: { type: :string },
                  discountPercent: { type: :number },
                  discountedPrice: { type: :number },
                  displayOrder: { type: :integer },
                  doNotRenew: { type: :boolean },
                  externalPlanCd: { type: :string },
                  lastUpdated: { type: :string },
                  offeredServiceId: { type: :integer },
                  performancePayPrice: { type: :number },
                  planEffectiveDate: { type: :string },
                  planExpirationDate: { type: :string },
                  planId: { type: :integer },
                  quantity: { type: :integer },
                  retailPrice: { type: :integer },
                  revenuePerUnit: { type: :number },
                  serviceType: { type: :number },
                  totalDisccountedPrice: { type: :number },
                  totalRevenue: { type: :number },
                  totalTrueCost: { type: :number }
                }
              }
            },
            planStatus: { type: :string },
            planType: { type: :integer },
            productSubType: { type: :string },
            recurringPaymentAmt: { type: :number },
            renewalPlan: {
              type: :array,
              items: {
                properties: {
                  _ref: { type: :string },
                  class: { type: :string }
                }
              }
            },
            renewalPlanId: { type: :integer },
            shortDescription: { type: :string },
            species: { type: :integer }
          }
        },
        contract_application: {
          type: :object,
          properties: {
            validatedFieldList: {
              type: :array,
              items: { type: :string }
            },
            location: {
              type: :object,
              properties: {
                id: { type: :integer }
              }
            },
            plan: {
              type: :object,
              properties: {
                id: { type: :integer }
              }
            },
            externalLocationCd: { type: :integer },
            externalPlanCd: { type: :integer },
            salutation: { type: :string },
            firstName: { type: :string },
            middleInitial: { type: :string },
            lastName: { type: :string },
            address1: { type: :string },
            address2: { type: :string },
            city: { type: :string },
            state: { type: :string },
            postalCode: { type: :integer },
            country: { type: :string },
            phone1: { type: :integer },
            phone1Type: { type: :string },
            phone2: { type: :integer },
            phone2Type: { type: :string },
            email: { type: :string },
            portalUsername: { type: :string },
            externalClientCd: { type: :integer },
            externalMemberCd: { type: :integer },
            memberName: { type: :string },
            memberAge: { type: :string },
            gender: { type: :string },
            initiatedByProfessional: {
              type: :object,
              properties: {
                id: { type: :integer }
              }
            },
            primaryCareProfessional: {
              type: :object,
              properties: {
                id: { type: :integer }
              }
            },
            initiatedByProfessionalCd: { type: :integer },
            primaryCareProfessionalCd: { type: :integer },
            payOption: { type: :string },
            payMethod: { type: :string },
            paymentName: { type: :string },
            accountNbrForDisplay: { type: :integer },
            accountNbr: { type: :integer },
            institutionName: { type: :string },
            bankAccountHolderType: { type: :string },
            bankAccountType: { type: :string },
            bankRoutingNbr: { type: :integer },
            paymentaddressSameAsAccount: true,
            expirationMonth: { type: :integer },
            expirationYear: { type: :integer },
            securityCode: { type: :integer },
            externalPaymentProfileId: { type: :integer },
            optionalPlanServices: {
              type: :array,
              items: { type: :object }
            }
          }
        }
      },
      service: {
        type: :object,
        properties: {
          services: {
            type: :array,
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
                  id: { type: :integer },
                  shortDescription: { type: :string }
                }
              },
              cost: { type: :number },
              dateCreated: { type: :string },
              discountPercent: { type: :number },
              discountedPrice: { type: :number },
              displayOrder: { type: :integer },
              doNotRenew: { type: :boolean },
              externalPlanCd: { type: :integer },
              lastUpdated: { type: :string },
              offeredServiceId: { type: :integer },
              performancePayPrice: { type: :number },
              planEffectiveDate: { type: :string },
              planExpirationDate: { type: :string },
              planId: { type: :integer },
              quantity: { type: :integer },
              retailPrice: { type: :number },
              revenuePerUnit: { type: :number },
              serviceType: { type: :string },
              totalDiscountedPrice: { type: :number },
              totalRevenue: { type: :number },
              totalTrueCost: { type: :number }
            }
          }
        }
      },
      paths: {},
      servers: [
        {
          url: 'http://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'localhost:3000/'
            }
          }
        }
      ]
    }
  }
end
