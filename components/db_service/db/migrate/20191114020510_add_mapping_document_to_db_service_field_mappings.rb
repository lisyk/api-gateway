class AddMappingDocumentToDbServiceFieldMappings < ActiveRecord::Migration[6.0]
  def change
    add_column :db_service_field_mappings, :mapping_document, :string
  end
end
