class CreateDbServiceFieldMappings < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_field_mappings do |t|
      t.integer :endpoint_id
      t.integer :partner_field_id
      t.integer :vip_field_id
      t.boolean :translation_needed, defauld: false
      t.boolean :required, default: false
      t.string :translation_function

      t.timestamps
    end
    add_index :db_service_field_mappings, :endpoint_id
    add_index :db_service_field_mappings, :vip_field_id
    add_index :db_service_field_mappings, :partner_field_id
  end
end
