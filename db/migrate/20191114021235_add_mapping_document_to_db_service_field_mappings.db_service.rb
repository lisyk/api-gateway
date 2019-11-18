# This migration comes from db_service (originally 20191114020510)
class AddMappingDocumentToDbServiceFieldMappings < ActiveRecord::Migration[6.0]
  def change
    add_column :db_service_field_mappings, :mapping_document, :string
  end
end
