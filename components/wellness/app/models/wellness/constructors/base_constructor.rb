# frozen_string_literal: true

module Wellness
  module Constructors
    class BaseConstructor
      include ResponseLogger

      private

      def output_results(object, message)
        object.compact.empty? ? { message: ["No #{message} matched query"] } : object.compact
      end

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

      def translated_value(new_key, value, translate_to)
        translation = translate(new_key, value, translate_to)
        translation.nil? ? value : translation
      end

      def update_hash(hash)
        hash.keys.each do |key|
          next if skip_update?(key)

          if needs_complex_mapping?(key)
            hash = complex_field_mapping(hash, key)
            next
          end

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

      def update_complex_fields(hash, new_fields, old_fields, mapper)
        return hash if field_already_translated?(hash, new_fields)

        mapped_fields = send(mapper, hash)
        mapped_fields.keys.each do |key|
          hash[key] = mapped_fields[key]
        end
        delete_old_fields(old_fields, hash)
      end

      def delete_old_fields(deletable, hash)
        deletable.each do |old_field|
          hash.delete old_field
        end
        hash
      end

      def skip_update?(_key)
        false
      end

      def needs_complex_mapping?(_key)
        false
      end
    end
  end
end
