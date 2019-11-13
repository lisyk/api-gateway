module DbService
  class FieldMapping < ApplicationRecord
    belongs_to :partner_field
    belongs_to :vip_field
  end
end
