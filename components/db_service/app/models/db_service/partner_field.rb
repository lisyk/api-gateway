module DbService
  class PartnerField < ApplicationRecord
    belongs_to :partner
    has_many :field_mappings

    validates :field_name, presence: true
  end
end
