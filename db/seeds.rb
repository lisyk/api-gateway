# frozen_string_literal: true

# TODO: determine how production/staging will get new updates
#       protect against running in production or
#       run specific steps in specific environments ????

### Development and TEST ENV seed *****
if Rails.env.development? || Rails.env.test?
  def clean_up_db
    DbService::Translation.delete_all
    DbService::AgeGroupTranslation.delete_all
    DbService::PetContract.delete_all
  end

  def age_group_translations
    JSON.parse(File.read(File.expand_path('seed_files/age_group_translations.json', __dir__)))
  rescue StandardError => e
    puts "Age group translation file error: #{e.backtrace}"
  end

  def translations
    JSON.parse(File.read(File.expand_path('seed_files/translations.json', __dir__)))
  rescue StandardError => e
    puts "General translation file error: #{e.backtrace}"
  end

  def create_pet_contract_record
    DbService::PetContract.create!(pet_id: random_id,
                                   pet_uuid: generate_uuid,
                                   contract_app_id: random_id)
  end

  def random_id
    Time.current.usec
  end

  def generate_uuid
    SecureRandom.uuid
  end

  puts '******* removing all data ... ********'
  clean_up_db
  puts '******* seeding data ... *************'

  # translations
  age_group_translations.each do |translation|
    DbService::AgeGroupTranslation.create!(species: translation['species'],
                                           age_group: translation['age_group'],
                                           minimum_age: translation['minimum_age'])
  end

  translations.each do |translation|
    DbService::Translation.create!(concept_name: translation['concept_name'],
                                   translation_value: translation['translation_value'])
  end

  20.times do
    create_pet_contract_record
  end

  puts '****** data seeding done! ************'
end
