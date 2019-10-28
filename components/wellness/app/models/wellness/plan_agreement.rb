# frozen_string_literal: true
# this model is responsible for Agreements
# no other services handled by this model

module Wellness
  class PlanAgreement < Connect
    include Concerns::RequestConcern
    
  end
end