class AddPartnerValueTypeToDbServiceTranslations < ActiveRecord::Migration[6.0]
  change_table :db_service_translations, bulk: true do |t|
    t.string :partner_value_type, null: false
    t.string :gateway_value_type, null: false
  end
end
