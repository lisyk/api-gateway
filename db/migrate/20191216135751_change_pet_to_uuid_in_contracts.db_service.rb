# This migration comes from db_service (originally 20191216133501)
class ChangePetToUuidInContracts < ActiveRecord::Migration[6.0]
  def change
    add_column :db_service_pet_contracts, :pet_uuid, :uuid
  end
end
