module DbService
  class VipField < ApplicationRecord
    validates :field_name, presence: true
  end
end
