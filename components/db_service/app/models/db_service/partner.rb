module DbService
  class Partner < ApplicationRecord
    has_many :endpoints

    validates :name, :root_domain, presence: true
    validates :name, :root_domain, uniqueness: true
  end
end
