# This migration comes from db_service (originally 20191112184859)
class CreateDbServiceVipFields < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_vip_fields do |t|
      t.string 'field_name'
      t.string 'field_data_type'

      t.timestamps
    end
  end
end
