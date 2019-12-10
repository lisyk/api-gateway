# frozen_string_literal: true

module Wellness
  module Services
    module ContractAppMapperService
      def map_phone_fields(contract)
        phone_fields = {}
        %w[phone1 phone1Type phone2 phone2Type].each do |field|
          phone_fields[field] = contract[field]
        end

        new_phone_fields = {}
        if phone_fields['phone1Type'] == 'M'
          new_phone_fields['mobile'] = phone_fields['phone1']
        else
          new_phone_fields['phone'] = phone_fields['phone1']
        end

        return new_phone_fields if phone_fields['phone2'].blank?

        if phone_fields['phone2Type'] == 'M' && new_phone_fields['mobile'].present?
          new_phone_fields['alternate_phone'] = phone_fields['phone2']
        elsif phone_fields['phone2Type'] == 'M'
          new_phone_fields['mobile'] = phone_fields['phone2']
        elsif new_phone_fields['phone'].present?

          new_phone_fields['alternate_phone'] = phone_fields['phone2']
        else
          binding.pry
          new_phone_fields['phone'] = phone_fields['phone2']
        end

        new_phone_fields
      end

      def map_address_fields(contract); end
    end
  end
end
