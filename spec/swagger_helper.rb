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
    'api_gateway/v1/swagger.json' => {
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
          authentication: {
            type: :object,
            properties: {
              token: { type: :string }
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
              default: 'localhost:3111/'
            }
          }
        }
      ]
    },
    'wellness/v1/swagger.json' => {
      openapi: '3.0.0',
      info: {
        title: 'Wellness Integration Engine',
        version: 'v1',
        description: 'Wellness Integration Engine Documentation'
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
          plan_get_response_list: {
            type: :object,
            properties: {
              plans: { type: :array, items: { '$ref' => '#components/schemas/plan_get_response' } }
            }
          },
          plan_get_response: {
            type: :object,
            properties: {
              id: { type: :integer, example: 5_477_684 },
              age_group: { type: :integer, example: 1, nullable: true },
              auto_renew: { type: :boolean, example: true, nullable: true },
              created_at: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
              sort_order: { type: :integer, example: 10, nullable: true },
              code: { type: :string, example: '10001', nullable: true },
              updated_at: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
              long_description: {
                type: :string,
                example: '<b>The Puppy Wellness Plan Includes:</b><div><ul><li>3 Complete Physical Exams</li><li>Core Vaccination Series as Recommended by Your Veterinarian - Includes 5-in-1 (DAP/Parvo), Lepto 4, Bordetella and Rabies</li><li>2 Fecal Tests</li><li>2 Deworming Treatments - Roundworms and Hookworms</li><li>Microchip I.D. and Registration</li></ul><div><br></div></div><div><br></div>',
                nullable: true
              },
              paid_in_full_discount: { type: :number, example: 0, nullable: true },
              payment_term: { type: :integer, example: 12, nullable: true },
              full_plan_price: { type: :number, example: 263.4, nullable: true },
              plan_services: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/offered_service_get_response'
                },
                nullable: true
              },
              recurring_plan_payment_total: { type: :number, example: 21.95, nullable: true },
              short_description: { type: :string, example: 'Puppy Wellness Plan', nullable: true },
              species_id: { type: :string, example: 'aa49c6a9-a4e8-4a19-bea0-059739291646', nullable: true }
            }
          },
          service_list: {
            type: :object,
            properties: {
              services: { type: :array, items: { '$ref' => '#components/schemas/service' } }
            }
          },
          service: {
            type: :object,
            properties: {
              services: {
                type: :array,
                items: {
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
          agreement: {
            type: :object,
            properties: {
              document: {
                type: :string,
                format: :binary,
                description: 'Binary-encoded PDF agreement document'
              }
            }
          },
          contract_service_list: {
            type: :object,
            properties: {
              contract_services: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    product_id: { type: :integer, example: 5_477_611 },
                    offered_service_id: { type: :integer, example: 5_477_232 },
                    service_description: { type: :string, example: 'Fecal Test' },
                    service_price: { type: :number, example: 21.95 },
                    available_quantity: { type: :integer, example: 3 }
                  }
                }
              }
            }
          },
          offered_service_get_response: {
            type: :object,
            properties: {
              id: { type: :integer, example: 5_428_856 },
              offered_service: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 5_428_799 },
                  short_description: { type: :string, example: 'Wellness Examination', nullable: true }
                }
              },
              plan: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 5_428_455 },
                  short_description: { type: :string, example: 'Puppy Wellness Plan', nullable: true }
                }
              },
              cost: { type: :number, example: 15.99, nullable: true },
              created_at: { type: :string, example: '2019-02-01T16:56:55Z', nullable: true },
              discount_percent: { type: :number, example: 50, nullable: true },
              discounted_price: { type: :number, example: 17.5, nullable: true },
              sort_order: { type: :integer, example: 10, nullable: true },
              code: { type: :number, example: nil, nullable: true },
              updated_at: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
              plan_id: { type: :integer, example: 5_428_455, nullable: true },
              plan_quantity: { type: :integer, example: 3, nullable: true },
              price: { type: :number, example: 35, nullable: true },
              revenue_per_unit: { type: :number, example: 21.1, nullable: true },
              is_optional: { type: :boolean, example: false, nullable: true }
            }
          },
          contract_application_request_list: {
            type: :array,
            items: {
              '$ref' => '#/components/schemas/contract_application_request'
            }
          },
          contract_application_request: {
            type: :object,
            properties: {
              owner_first_name: { type: :string, example: 'Harry' },
              owner_last_name: { type: :string, example: 'Potter' },
              address: { type: :string, example: '4 Privet Drive' },
              city: { type: :string, example: 'Morino Valley' },
              state: { type: :string, example: 'CA' },
              zip: { type: :string, example: '92551' },
              country: { type: :string, example: 'US' },
              email: { type: :string, example: 'HarryPotter@Hogwarts.edu' },
              owner_id: { type: :string, example: '1000', nullable: true },
              pet_id: { type: :string, example: '1', nullable: true },
              pet_name: { type: :string, example: 'Hedwig' },
              gender: { type: :string, example: 'F', nullable: true },
              payment_method: { type: :string, example: 'credit' },
              card_name: { type: :string, example: 'MasterCard' },
              card_number: { type: :string, example: '5354' },
              expiration_month: { type: :integer, example: 1 },
              expiration_year: { type: :integer, example: 2025 },
              mobile: { type: :string, example: '9494814601', nullable: true },
              phone: { type: :string, example: '9494814602', nullable: true },
              alternate_phone: { type: :string, example: '9494814603', nullable: true }
            }
          },
          contract_application_response_list: {
            type: :array,
            items: {
              '$ref' => '#/components/schemas/contract_application_response'
            }
          },
          contract_application_response: {
            type: :object,
            properties: {
              owner_first_name: { type: :string, example: 'Harry', nullable: true },
              owner_last_name: { type: :string, example: 'Potter', nullable: true },
              address: { type: :string, example: '4 Privet Drive', nullable: true },
              city: { type: :string, example: 'Morino Valley', nullable: true },
              state: { type: :string, example: 'CA', nullable: true },
              zip: { type: :string, example: '92551', nullable: true },
              country: { type: :string, example: 'US', nullable: true },
              email: { type: :string, example: 'HarryPotter@Hogwarts.edu', nullable: true },
              owner_id: { type: :string, example: '1000', nullable: true },
              pet_id: { type: :string, example: '1', nullable: true },
              pet_name: { type: :string, example: 'Hedwig', nullable: true },
              gender: { type: :string, example: 'F', nullable: true },
              payment_method: { type: :string, example: 'credit', nullable: true },
              card_name: { type: :string, example: 'MasterCard', nullable: true },
              card_number: { type: :string, example: '5354', nullable: true },
              expiration_month: { type: :integer, example: 1, nullable: true },
              expiration_year: { type: :integer, example: 2025, nullable: true },
              mobile: { type: :string, example: '9494814601', nullable: true },
              phone: { type: :string, example: '9494814602', nullable: true },
              alternate_phone: { type: :string, example: '9494814603', nullable: true },
              status: { type: :string, example: '5', nullable: true }
            }
          },
          vip_finalize_application: {
            type: :object,
            allOf: [
              { '$ref' => '#/components/schemas/finalize_application' },
              { '$ref' => '#/components/schemas/contract_application_response' }
            ]
          },
          initialize_application_response: {
            type: :object,
            properties: {
              contract_application_id: { type: :integer, example: 1_000_015_424 },
              info: {
                type: :array,
                items: {
                  type: :string,
                  example: 'Please download agreement and return via PUT /submit_agreement/:id'
                }
              },
              agreement_document_base_64: { type: :string, description: 'Base-64 encoded agreement document.' }
            }
          },
          finalize_application: {
            type: :object,
            properties: {
              initial_payment_option: {
                type: :integer,
                enum: [1, 12],
                example: 12,
                description: 'Payment term (paid in full vs. 12 month term)'
              },
              payment_token: { type: :string, example: 'test_token' }
            }
          },
          contract_get_response_list: {
            type: :array,
            items: {
              '$ref' => '#/components/schemas/contract_get_response'
            }
          },
          contract_get_response: {
            type: :object,
            properties: {
              id: { type: :integer, example: 1_000_015_201, nullable: true },
              address: { type: :string, example: '4 Privet Drive', nullable: true },
              contract_period: { type: :string, nullable: true },
              date_created: { type: :string, example: '2019-12-30T21:23:05Z', nullable: true },
              owner_id: { type: :string, example: '12312351324510', nullable: true },
              clinic_location_id: { type: :string, example: '010265', nullable: true },
              pet_id: { type: :string, example: '112314123412351', nullable: true },
              last_updated: { type: :string, example: '2019-12-30T21:23:05Z', nullable: true },
              age: { type: :string, example: '1Y 2M', nullable: true },
              pet_name: { type: :string, example: 'Hedwig', nullable: true },
              phone: { type: :string, example: '9494814601', nullable: true },
              alternate_phone: { type: :string, example: '9494814602', nullable: true },
              zip: { type: :string, example: '92551', nullable: true }
            }
          },
          auth_error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :string,
                  example: 'Authentication token is not provided!'
                }
              },
              auth_status: { type: :string, example: 'unauthorized' }
            }
          },
          not_found_error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  type: :string,
                  example: 'Not found.'
                }
              }
            }
          },
          malformed_request_error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: {
                  object: { type: :string, example: 'com.bwse.model.api.ContractApplication' },
                  field: { type: :string, example: 'email' },
                  'rejected-value'.to_sym => { type: :string, example: 'Harry.Potter@Hogwarts.edu' },
                  message: { type: :string, example: 'email with value [Harry.Potter@Hogwarts.edu] does not pass custom validation' }
                }
              }
            }
          },
          not_completed_error: {
            type: :object,
            properties: {
              errors: {
                type: :array,
                items: { type: :string, example: 'Contract application was not completed by provider.' }
              },
              response: {
                type: :object
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
            defaultHost: {
              default: 'localhost:3111/'
            }
          }
        }
      ]
    }
  }
end
