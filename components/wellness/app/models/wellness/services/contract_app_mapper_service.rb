# frozen_string_literal: true

module Wellness
  module Services
    module ContractAppMapperService
      def map_phone_fields(contract)
        phone_fields = {}
        %w[phone1 phone1Type phone2 phone2Type].each do |field|
          phone_fields[field] = contract[field]
        end
        new_phone_fields = map_phone_1(phone_fields)
        return new_phone_fields if phone_fields['phone2'].blank?

        map_phone_2(phone_fields, new_phone_fields)
      end

      def map_address_fields(contract)
        address_fields = []
        %w[address1 address2].each do |field|
          address_fields << contract[field].strip if contract[field].present?
        end
        address_fields.join(' ').strip
      end

      private

      def map_phone_1(phone_fields)
        if phone_fields['phone1Type'] == 'M'
          { 'mobile' => phone_fields['phone1'] }
        else
          { 'phone' => phone_fields['phone1'] }
        end
      end

      def map_phone_2(phone_fields, new_phone_fields)
        if phone_fields['phone2Type'] == 'M' && new_phone_fields['mobile'].present?
          new_phone_fields['alternate_phone'] = phone_fields['phone2']
        elsif phone_fields['phone2Type'] == 'M'
          new_phone_fields['mobile'] = phone_fields['phone2']
        elsif new_phone_fields['phone'].present?
          new_phone_fields['alternate_phone'] = phone_fields['phone2']
        else
          new_phone_fields['phone'] = phone_fields['phone2']
        end

        new_phone_fields
      end
    end
  end
end
