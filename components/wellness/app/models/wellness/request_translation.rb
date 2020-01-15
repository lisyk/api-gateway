# frozen_string_literal: true

module Wellness
  class RequestTranslation
    include Services::ContractAppTranslatorService
    include Services::ResponseLogger

    attr_accessor :request

    def initialize(request, skip_defaults = false)
      @request = parse_request(request)
      @skip_defaults = skip_defaults
    end

    def translate_request
      log_original_response(request)
      update_request
    end

    private

    def update_request
      request.keys.each do |key|
        translate_object(request, key)
        next unless request[key].is_a? Array

        translate_nested(request[key])
      end
      update_default_fields unless @skip_defaults
      translate_fields
      request
    end

    def translate_nested(nested_items)
      nested_items.each do |request_item|
        if request_item.is_a? Hash
          request_item.keys.map { |int_key| translate_object(request_item, int_key) }
        end
      end
    end

    def translate_object(object, key)
      field_to_replace = constructor_mapper[key]
      value = object.delete key
      new_key = field_to_replace || key
      object[new_key] = value
    end

    def constructor_mapper
      file_name = 'mapper.json'
      file_path = "../../../lib/mappers/vcp/#{file_name}"
      mapper_file = File.expand_path(file_path, __dir__)
      JSON.parse(File.read(mapper_file))
    end

    def update_default_fields
      request['paymentaddressSameAsAccount'] = true
      request['payOption'] = 'CC'
      request['portalUsername'] = request['email']
    end

    def translate_fields
      translate_phone_fields
      translate_cc_fields
      translate_code_fields
    end

    def translate_phone_fields
      return unless translate_field?(%w[phone mobile alternate_phone])

      if request['mobile'].present?
        translate_mobile
      else
        request['phone1'] = request.delete('phone')
        request['phone1Type'] = 'H'
      end
    end

    def translate_mobile
      request['phone1'] = request.delete('mobile')
      request['phone1Type'] = 'M'
      request['phone2'] = request.delete('phone')
      request['phone2Type'] = 'H' unless request['phone2'].nil?
    end

    def translate_cc_fields
      return unless translate_field?(%w[payMethod])

      value = request['payMethod']
      request['payMethod'] = translate_general('card_name', value, :partner)
    end

    def translate_code_fields
      return unless translate_field?(%w[externalPlanCd externalLocationCd])

      plan_code = request['externalPlanCd']
      clinic_location_id = request['externalLocationCd']
      request['plan'] = { 'id' => plan_code }
      request['location'] = { 'id' => clinic_location_id }
    end

    def parse_request(request)
      JSON.parse(request.body.read)
    end

    def translate_field?(translation_values)
      translation_values.each do |value|
        return true if @request[value].present?
      end
      false
    end
  end
end
