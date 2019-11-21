# frozen_string_literal: true

module Wellness
  module Constructors
    class Constructor
      def log_original_response(response)
        Rails.logger.info('Original Response:' => response)
      end
    end
  end
end
