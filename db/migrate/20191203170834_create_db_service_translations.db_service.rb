# This migration comes from db_service (originally 20191203163925)
class CreateDbServiceTranslations < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_translations do |t|
      t.string 'concept_name', null: false
      t.string 'partner_value'
      t.string 'gateway_value', null: false

      t.timestamps
    end
  end
end
