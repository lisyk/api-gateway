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
          plan_object: {
            type: 'object',
            properties: {
              plan_map: { '$ref' => '#/components/schemas/plan_map' }
            }
          },
          plan_list: {
            type: 'array',
            items: { '$ref' => '#/components/schemas/plan_map' }
          },
          plan_map: {
            type: 'object',
            properties: {
              plans: {
                id: { type: :integer, nullable: false, required: true },
                version: { type: :integer },
                ageGroup: { type: :integer },
                autoRenew: { type: :boolean },
                dateCreated: { type: :string },
                displayOrder: { type: :integer },
                externalPlanCd: { type: :string, nullable: false, required: true },
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
              species: { type: :integer },
              vip_mapped_attribues: {
                  type: :array,
                    items: {
                      properties: {
                        species: { type: :integer },
                        age_group: { type: :string },
                        sex: { type: :string }
                      }
                  }
              }
            }
          },
            required: %w[id ageGroup externalPlanCd]
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
