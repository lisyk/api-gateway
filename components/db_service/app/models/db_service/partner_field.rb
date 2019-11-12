module DbService
  class PartnerField < ApplicationRecord
    belongs_to :partner

    validates :field_name, presence: true
  end
end
