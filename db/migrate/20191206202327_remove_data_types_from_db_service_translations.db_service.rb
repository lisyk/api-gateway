# This migration comes from db_service (originally 20191206195550)
class RemoveDataTypesFromDbServiceTranslations < ActiveRecord::Migration[6.0]
  change_table :db_service_translations, bulk: true do |t|
    t.remove :partner_value
    t.remove :gateway_value
    t.json :translation_value
  end
end
