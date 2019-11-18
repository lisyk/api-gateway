module DbService
  class FieldMapping < ApplicationRecord
    belongs_to :partner_field
    belongs_to :vip_field

    scope :wellness_plans, -> { where(:mapping_document => 'wellness_plan') }
    scope :need_translation, -> { where(:translation_needed => true) }
    scope :plan_mapping, -> (field) { joins(:partner_field).where(db_service_partner_fields: { field_name: field }) }
  end
end
