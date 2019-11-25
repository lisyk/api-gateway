# frozen_string_literal: true

module DbService
  class Partner < ApplicationRecord
    has_many :endpoints, dependent: :destroy
    has_many :partner_fields, dependent: :destroy

    validates :name, :root_domain, presence: true
    validates :name, :root_domain, uniqueness: true

    scope :vcp, -> { where(name: 'vcp') }
  end
end
