module DbService
  class Partner < ApplicationRecord
    validates :name, :root_domain, presence: true
    validates :name, :root_domain, uniqueness: true
  end
end
