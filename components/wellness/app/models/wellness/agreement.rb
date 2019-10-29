# frozen_string_literal: true

# this model is responsible for Agreements
# no other services handled by this model

module Wellness
  class Agreement < Connect
    include Concerns::RequestConcern
  end
end