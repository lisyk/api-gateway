# frozen_string_literal: true

module Wellness
  class RequestTranslation < Constructors::ResponseLogger
    include Wellness::Services::ContractAppTranslatorService

    attr_accessor :request, :translation_type

    def initialize(request, translation_type)
      @request = parse_request(request)
      @translation_type = translation_type
    end

    def translate_request
      log_original_response(@request)
      update_request
    end

    private

    def update_request
      @request.keys.each do |key|
        field_to_replace = constructor_mapper[key]
        value = @request.delete key
        new_key = field_to_replace || key
        @request[new_key] = value
      end
      update_default_fields
      translate_fields
      @request
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
