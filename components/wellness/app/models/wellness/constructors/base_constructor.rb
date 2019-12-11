# frozen_string_literal: true

module Wellness
  module Constructors
    class BaseConstructor < ResponseLogger
      private

      def update_object(object)
        update_nested_field_names(object)
        object
      end

      def update_nested_field_names(object)
        if object.is_a? Hash
          update_hash(object)
        elsif object.is_a? Array
          update_array(object)
        end
      end

      def translated_value(new_key, value, contract, translate_to)
        translated_value = translate(new_key, value, contract, translate_to)
        translated_value.nil? ? value : translated_value
      end

      def update_hash(hash)
        hash.keys.each do |key|
          field_to_replace = constructor_mapper[key]
          value = hash.delete key
          next if field_to_replace.nil? || ignore_field?(key)

          new_key = field_to_replace
          hash[field_to_replace] = translated_value(new_key, value, translate_to: :gateway)
          update_nested_field_names(hash[field_to_replace])
        end
      end

      def update_array(array)
        array.each do |item|
          update_nested_field_names(item)
        end
      end

      def delete_old_fields(deletable, hash)
        deletable.each do |old_field|
          hash.delete old_field
        end
        hash
      end
    end
  end
end
