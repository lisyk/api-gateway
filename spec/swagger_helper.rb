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
          plan_list: {
            type: :object,
            properties: {
              plans: { type: :array, items: { '$ref' => '#components/schemas/plan' } }
            }
          },
          plan: {
            type: :object,
            properties: {
              id: { type: :integer, example: 5_477_684 },
              age_group: { type: :integer, example: 1 },
              auto_renew: { type: :boolean, example: true },
              created_at: { type: :string, example: '2019-02-18T18:20:12Z' },
              sort_order: { type: :integer, example: 10 },
              code: { type: :string, example: '10001' },
              updated_at: { type: :string, example: '2019-02-18T18:20:12Z' },
              long_description: {
                type: :string,
                example: '<b>The Puppy Wellness Plan Includes:</b><div><ul><li>3 Complete Physical Exams</li><li>Core Vaccination Series as Recommended by Your Veterinarian - Includes 5-in-1 (DAP/Parvo), Lepto 4, Bordetella and Rabies</li><li>2 Fecal Tests</li><li>2 Deworming Treatments - Roundworms and Hookworms</li><li>Microchip I.D. and Registration</li></ul><div><br></div></div><div><br></div>'
              },
              paid_in_full_discount: { type: :number, example: 0 },
              payment_term: { type: :integer, example: 12 },
              full_plan_price: { type: :number, example: 263.4 },
              plan_services: {
                type: :array,
                items: {
                  '$ref' => '#/components/schemas/offered_service'
                }
              },
              recurring_plan_payment_total: { type: :number, example: 21.95 },
              short_description: { type: :string, example: 'Puppy Wellness Plan' },
              species_id: { type: :string, example: 'aa49c6a9-a4e8-4a19-bea0-059739291646' }
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
          offered_service: {
            type: :object,
            properties: {
              id: { type: :integer, example: 5_428_856 },
              offered_service: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 5_428_799 },
                  short_description: { type: :string, example: 'Wellness Examination' }
                }
              },
              plan: {
                type: :object,
                properties: {
                  id: { type: :integer, example: 5_428_455 },
                  short_description: { type: :string, example: 'Puppy Wellness Plan' }
                }
              },
              cost: { type: :number, example: 15.99, nullable: true },
              created_at: { type: :string, example: '2019-02-01T16:56:55Z' },
              discount_percent: { type: :number, example: 50, nullable: true },
              discounted_price: { type: :number, example: 17.5 },
              sort_order: { type: :integer, example: 10 },
              code: { type: :number, example: nil, nullable: true },
              updated_at: { type: :string, example: '2019-02-18T18:20:12Z' },
              plan_id: { type: :integer, example: 5_428_455 },
              plan_quantity: { type: :integer, example: 3 },
              price: { type: :number, example: 35 },
              revenue_per_unit: { type: :number, example: 21.1, nullable: true },
              is_optional: { type: :boolean, example: false }
            }
          },
          partner_contract_application_list: {
            type: :array,
            items: {
              '$ref' => '#/components/schemas/partner_contract_application'
            }
          },
          partner_contract_application: {
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
              externalClientCd: { type: :string },
              externalMemberCd: { type: :string },
              memberName: { type: :string },
              memberAge: { type: :string },
              gender: { type: :string, nullable: true },
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
              initiatedByProfessionalCd: { type: :integer, nullable: true },
              primaryCareProfessionalCd: { type: :integer, nullable: true },
              payOption: { type: :string },
              payMethod: { type: :string },
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
              externalPaymentProfileId: { type: :string, nullable: true },
              optionalPlanServices: {
                type: :array,
                items: { type: :object }
              }
            }
          },
          vip_contract_application_list: {
            type: :array,
            items: {
              '$ref' => '#/components/schemas/vip_contract_application'
            }
          },
          vip_contract_application: {
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
              card_number: { type: :string, example: '5354', nullable: true },
              expiration_month: { type: :integer, example: 1, nullable: true },
              expiration_year: { type: :integer, example: 2025, nullable: true },
              anyOf: {
                mobile: { type: :string, example: '9494814601' },
                phone: { type: :string, example: '9494814602' },
                alternate_phone: { type: :string, example: '9494814603' }
              }
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
