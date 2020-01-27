class CreateDbServiceAgeGroupTranslations < ActiveRecord::Migration[6.0]
  def change
    create_table :db_service_age_group_translations do |t|
      t.integer 'species', null: false
      t.integer 'age_group', null: false
      t.integer 'minimum_age'

      t.timestamps
    end
  end
end
