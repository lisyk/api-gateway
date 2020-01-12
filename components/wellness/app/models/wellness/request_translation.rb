# frozen_string_literal: true

module Wellness
  class RequestTranslation
    include Services::ContractAppTranslatorService
    include Services::ResponseLogger

    attr_accessor :request, :translation_type

    def initialize(request, translation_type, skip_defaults = false)
      @request = parse_request(request)
      @translation_type = translation_type
      @skip_defaults = skip_defaults
    end

    def translate_request
      log_original_response(@request)
      update_request
    end

    private

    def update_request
      request.keys.each do |key|
        translate_object(request, key)
        if request[key].is_a? Array
          request[key].each do |request_item|
            request_item.keys.map{|key| translate_object(request_item, key) } if request_item.is_a? Hash
          end
        end
      end
      return request if @skip_defaults

      update_default_fields
      translate_fields
      request
    end

    def translate_object(object, key)
      field_to_replace = constructor_mapper[key]
      value = object.delete key
      new_key = field_to_replace || key
      object[new_key] = value
    end

    def constructor_mapper
      file_name = "#{@translation_type}_request_mapper.json"
      file_path = "../../../lib/mappers/#{@translation_type}/#{file_name}"
      mapper_file = File.expand_path(file_path, __dir__)
      JSON.parse(File.read(mapper_file))
    end

    def update_default_fields
      @request['paymentaddressSameAsAccount'] = true
      @request['payOption'] = 'CC'
    end

    def translate_fields
      translate_phone_fields
      translate_cc_fields
    end

    def translate_phone_fields
      if @request['mobile'].present?
        @request['phone1'] = @request.delete('mobile')
        @request['phone1Type'] = 'M'
        @request['phone2'] = @request.delete('phone')
        @request['phone2Type'] = 'H' unless @request['phone2'].nil?
      else
        @request['phone1'] = @request.delete('phone')
        @request['phone1Type'] = 'H'
      end
    end

    def translate_cc_fields
      value = @request['payMethod']
      @request['payMethod'] = translate_general('card_name', value, :partner)
    end

    def parse_request(request)
      JSON.parse(request.body.read)
    end
  end
end
