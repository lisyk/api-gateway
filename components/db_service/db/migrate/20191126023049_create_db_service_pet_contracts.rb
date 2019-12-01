class CreateDbServicePetContracts < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_pet_contracts do |t|
      t.integer "pet_id"
      t.integer "contract_app_id"

      t.timestamps
    end
  end
end
