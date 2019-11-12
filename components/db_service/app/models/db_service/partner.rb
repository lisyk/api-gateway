module DbService
  class Partner < ApplicationRecord
    has_many :endpoints, dependent: :destroy
    has_many :partner_fields, dependent: :destroy

    validates :name, :root_domain, presence: true
    validates :name, :root_domain, uniqueness: true
  end
end
