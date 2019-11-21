# This migration comes from db_service (originally 20191111225352)
class CreateDbServiceEndpoints < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_endpoints do |t|
      t.integer 'partner_id'
      t.string 'endpoint_name'
      t.string 'protocol'
      t.string 'subdomain'
      t.string 'api_route'

      t.timestamps
    end
    add_index :db_service_endpoints, :partner_id
  end
end
