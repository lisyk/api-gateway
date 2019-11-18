module DbService
  class FieldMapping < ApplicationRecord
    belongs_to :partner_field
    belongs_to :vip_field

    scope :wellness_plans, -> { where(:mapping_document => 'wellness_plan') }
    scope :need_translation, -> { where(:translation_needed => true) }
  end
end
