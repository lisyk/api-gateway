class CreateDbServicePartners < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_partners do |t|
      t.string 'name'
      t.string 'root_domain'

      t.timestamps
    end
  end
end
