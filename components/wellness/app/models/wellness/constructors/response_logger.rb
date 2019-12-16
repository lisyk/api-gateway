# frozen_string_literal: true

module Wellness
  module Constructors
    module ResponseLogger
      def log_original_response(response)
        Rails.logger.info({ 'Original Response:' => response }.to_json)
      end
    end
  end
end
