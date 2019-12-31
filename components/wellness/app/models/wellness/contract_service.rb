# frozen_string_literal: true

module Wellness
  class ContractService < Connect
    include Concerns::RequestConcern

    def available_services
      return origin_services if origin_services.blank?

      services_builder
    end

    def services_builder
      contract_services = []
      origin_services.first['contractPeriodServices'].each do |service|
        contract_services << {
          product_id: plan_id(service),
          offered_service_id: service_id(service),
          service_description: service_name(service),
          service_price: price(service),
          available_quantity: quantity(service)
        }
      end
      contract_services
    end

    def plan_id(service)
      service['planService']['plan']['id']
    end

    def service_id(service)
      service['planService']['offeredService']['id']
    end

    def service_name(service)
      service['planService']['offeredService']['shortDescription']
    end

    def price(service)
      service['planService']['discountedPrice']
    end

    def quantity(service)
      q = service['availableQuantity']
      q.positive? ? q : "#{service_name(service)} coverage is no longer available."
    end

    def origin_services
      api_request
    end
  end
end
