class CreateDbServicePartnerFields < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_partner_fields do |t|
      t.integer 'partner_id'
      t.string 'field_name'
      t.string 'field_data_type'

      t.timestamps
    end
    add_index :db_service_partner_fields, :partner_id
  end
end
