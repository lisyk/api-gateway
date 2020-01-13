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
          agreement_upload_response: {
            type: :object,
            properties: {
              id: { type: :string, nullable: true, example: '1000015477' },
              success: {
                type: :array,
                items: {
                  type: :string,
                  example: 'Signed agreement posted successfully.'
                }
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
          consume_contract_services: {
            type: :object,
            properties: {
              type: :object,
              serviceConsumptionList: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    owner_id: { type: :string, example: '1000' },
                    external_consumption_id: { type: :string, example: '16600' },
                    external_invoice_date: { type: :string, example: '2019-02-18T18:20:12Z' },
                    external_invoice_number: { type: :string, example: '8877' },
                    clinic_location_id: { type: :string, example: '010265' },
                    pet_id: { type: :string, example: '1333' },
                    external_service_cd: { type: :string, example: '36600' },
                    external_service_name: { type: :string, example: 'Joo' },
                    external_service_type: { type: :string, example: 'vaccine' },
                    posting_date: { type: :string, example: '2019-02-18T18:20:12Z' },
                    quantity: { type: :number, example: 1 },
                    service_date: { type: :string, example: '2019-02-18T18:20:12Z' },
                    service_delivered_by_cd: { type: :string, example: '4433' },
                    service_delivered_by_name: { type: :string, example: 'JJJ' },
                    invoiced_price: { type: :number, example: 17.5, nullable: true },
                    discount_amt: { type: :number, example: 0, nullable: true }
                  }
                }
              }
            }
          },
          consume_contract_services_response: {
            type: :object,
            properties: {
              serviceConsumptionList: {
                type: :array,
                items: {
                  type: :object,
                  properties: {
                    id: { type: :integer, example: 848 },
                    contract: {
                      type: :object,
                      properties: {
                        id: { type: :integer, example: 11, nullable: true }
                      }
                    },
                    contractId: { type: :integer, example: '34343', nullable: true },
                    contractPeriodId: { type: :string, example: '34444', nullable: true },
                    coverageType: { type: :number, example: 3 },
                    dateCreated: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
                    discountAmt: { type: :number, example: 0 },
                    discountedPrice: { type: :number, example: 17.5, nullable: true },
                    entryMethod: { type: :string, example: 'auto', nullable: true },
                    externalClientCd: { type: :string, example: '36600', nullable: true },
                    externalConsumptionId: { type: :string, example: '344600', nullable: true },
                    externalGender: { type: :string, example: 'm', nullable: true },
                    externalInvoiceDate: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
                    externalInvoiceNumber: { type: :string, example: '00020', nullable: true },
                    externalLocationCd: { type: :string, example: '333', nullable: true },
                    externalMemberCd: { type: :string, example: '333300', nullable: true },
                    externalServiceCd: { type: :string, example: '777887', nullable: true },
                    externalServiceName: { type: :string, example: 'Lui', nullable: true },
                    externalServiceType: { type: :string, example: 'vaccine', nullable: true },
                    externalSpeciesCd: { type: :string, example: '99999', nullable: true },
                    externalStatus: { type: :string, example: 'man', nullable: true },
                    externalUserCd: { type: :string, example: '666666', nullable: true },
                    gender: { type: :string, example: 'O', nullable: true },
                    invoicedPrice: { type: :number, example: 14.5, nullable: true },
                    lastUpdated: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
                    locationId: { type: :integer, example: 22, nullable: true },
                    notes: { type: :string, example: 'note1', nullable: true },
                    offeredService: { type: :string, example: 'vac', nullable: true },
                    performancePayPrice: { type: :number, example: 14.5, nullable: true },
                    postingDate: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
                    postingPeriod: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
                    quantity: { type: :number, example: 2, nullable: true  },
                    retailPrice: { type: :number, example: 24.5, nullable: true },
                    revenuePerUnit: { type: :number, example: 4.5, nullable: true },
                    serviceCommissionAmt: { type: :number, example: 4.5, nullable: true },
                    serviceCommissionType: { type: :string, example: 'comission', nullable: true },
                    serviceDate: { type: :string, example: '2019-02-18T18:20:12Z', nullable: true },
                    serviceDeliveredByCd: { type: :string, example: 'Kio', nullable: true },
                    serviceDeliveredByName: { type: :string, example: 'Jeeko', nullable: true },
                    serviceType: { type: :string, example: 'type', nullable: true },
                    speciesId: { type: :number, example: 2 },
                    status: { type: :string, example: 'status', nullable: true },
                    warnings: {
                      type: :array,
                      items: {
                        type: :object,
                        properties: {
                          code: { type: :string,
                                  example: 'serviceConsumption.externalClientCd.notFound.error',
                                  nullable: true },
                          errorCode: { type: :string, example: 'SCE-1000', nullable: true },
                          field: { type: :string, example: 'externalClientCd', nullable: true },
                          message: { type: :string, exampole: 'Client not found', nullable: true },
                          value: { type: :string, exampole: 'ex', nullable: true }
                        }
                      }
                    }
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
              clinic_location_id: { type: :integer, example: 5_426_720 },
              plan_code: { type: :integer, example: 5_428_455 },
              owner_first_name: { type: :string, example: 'Harry' },
              owner_last_name: { type: :string, example: 'Potter' },
              address: { type: :string, example: '4 Privet Drive' },
              city: { type: :string, example: 'Morino Valley' },
              state: { type: :string, example: 'CA' },
              zip: { type: :string, example: '92551' },
              country: { type: :string, example: 'US' },
              email: { type: :string, example: 'HarryPotter@Hogwarts.edu' },
              owner_id: { type: :string, example: 'd525ffb5', nullable: true },
              pet_id: { type: :string, example: 'd525ffb5-d6a7-41f9-a317-86a205a9e130', nullable: true },
              pet_name: { type: :string, example: 'Hedwig' },
              age: { type: :string, example: '1Y 2M', description: 'Also can accept integer year and datetime objects' },
              gender: { type: :string, example: 'F', nullable: true },
              payment_method: { type: :string, example: 'credit' },
              payment_name: { type: :string, example: 'Harry Potter' },
              card_name: { type: :string, example: 'Visa' },
              account_number: { type: :integer, example: 1111 },
              expiration_month: { type: :integer, example: 1 },
              expiration_year: { type: :integer, example: 2099 },
              initial_payment_option: { type: :integer, example: 12 },
              mobile: { type: :string, example: '9494814601', nullable: true },
              phone: { type: :string, example: '9494814602', nullable: true },
              alternate_phone: { type: :string, example: '9494814603', nullable: true },
              optional_plan_services: { type: :array, example: [] }
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
              clinic_location_id: { type: :string, example: '5426720', nullable: true },
              plan_code: { type: :string, example: '5428455', nullable: true },
              owner_first_name: { type: :string, example: 'Harry', nullable: true },
              owner_last_name: { type: :string, example: 'Potter', nullable: true },
              address: { type: :string, example: '4 Privet Drive', nullable: true },
              city: { type: :string, example: 'Morino Valley', nullable: true },
              state: { type: :string, example: 'CA', nullable: true },
              zip: { type: :string, example: '92551', nullable: true },
              country: { type: :string, example: 'US', nullable: true },
              email: { type: :string, example: 'HarryPotter@Hogwarts.edu', nullable: true },
              owner_id: { type: :string, example: 'd525ffb5', nullable: true },
              pet_id: { type: :string, example: 'd525ffb5-d6a7-41f9-a317-86a205a9e130', nullable: true },
              pet_name: { type: :string, example: 'Hedwig', nullable: true },
              age: { type: :string, example: '1Y 2M', description: 'Also can accept integer year and datetime objects', nullable: true },
              gender: { type: :string, example: 'F', nullable: true },
              payment_method: { type: :string, example: 'credit', nullable: true },
              payment_name: { type: :string, example: 'Harry Potter', nullable: true },
              card_name: { type: :string, example: 'Visa', nullable: true },
              account_number: { type: :integer, example: 1111, nullable: true },
              expiration_month: { type: :integer, example: 1, nullable: true },
              expiration_year: { type: :integer, example: 2099, nullable: true },
              initial_payment_option: { type: :integer, example: 12, nullable: true },
              mobile: { type: :string, example: '9494814601', nullable: true },
              phone: { type: :string, example: '9494814602', nullable: true },
              alternate_phone: { type: :string, example: '9494814603', nullable: true },
              optional_plan_services: { type: :array, example: [], nullable: true }
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
          },
          s3_upload_error: {
            type: :object,
            properties: {
              id: {
                type: :string, nullable: true, example: '1000015477'
              },
              errors: {
                type: :array,
                items: {
                  type: :string, example: 'Agreement not stored in S3 bucket.'
                }
              },
              success: {
                type: :array,
                items: {
                  type: :string, example: 'Signed agreement posted successfully.'
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
