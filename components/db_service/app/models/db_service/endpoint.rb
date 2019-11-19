# frozen_string_literal: true

module DbService
  class Endpoint < ApplicationRecord
    belongs_to :partner

    validates :endpoint_name, :protocol, presence: true
  end
end
