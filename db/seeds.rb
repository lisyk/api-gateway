# frozen_string_literal: true

def random_id
  Time.current.usec
end

def generate_uuid
  SecureRandom.uuid
end

def age_group_translations
  JSON.parse(File.read(File.expand_path('seed_files/age_group_translations.json', __dir__)))
end

def translations
  JSON.parse(File.read(File.expand_path('seed_files/translations.json', __dir__)))
end

def create_test_records_for_pet_contract_records
  # do NOT run this in staging or production
  puts '  Purge all pet_contract records'
  DbService::PetContract.delete_all

  puts '  create test pet_contract records'
  20.times do
    DbService::PetContract.create!(
      pet_id: random_id,
      pet_uuid: generate_uuid,
      contract_app_id: random_id
    )
  end
end

def rebuild_age_group_translations
  puts '  Purge all age_group_translations records'
  DbService::AgeGroupTranslation.delete_all

  puts '  create age_group_translations from json data'
  age_group_translations.each do |translation|
    DbService::AgeGroupTranslation.create!(
      species: translation['species'],
      age_group: translation['age_group'],
      minimum_age: translation['minimum_age']
    )
  end
end

def rebuild_translations
  puts '  Purge all translation records'
  DbService::Translation.delete_all

  puts '  create translations from json data'
  translations.each do |translation|
    DbService::Translation.create!(
      concept_name: translation['concept_name'],
      translation_value: translation['translation_value']
    )
  end
end

def seed_development
  create_test_records_for_pet_contract_records
  rebuild_age_group_translations
  rebuild_translations
end

def seed_test
  seed_development
end

def seed_staging
  seed_production
end

def seed_production
  # Long term we should find a better way to handle mapping updates for production and staging
  rebuild_age_group_translations
  rebuild_translations
end

puts '------------------------------'
puts "BEGIN DB seed: #{Rails.env}"
send("seed_#{Rails.env}".to_sym)
puts 'END DB seed'
puts '------------------------------'
