# frozen_string_literal: true

# TODO: determine how production/staging will get new updates
#       protect against running in production or
#       run specific steps in specific environments ????

### Development and TEST ENV seed *****
if Rails.env.development?
  def clean_up_db
    DbService::Partner.delete_all
    DbService::Endpoint.delete_all
    DbService::FieldMapping.delete_all
    DbService::PartnerField.delete_all
    DbService::VipField.delete_all
  end

  def vcp_plan_mapping
    JSON.parse(File.read(File.expand_path('seed_files/vcp_plan_mapping_seed.json', __dir__)))
  rescue StandardError => e
    puts "VCP plan mapping file error: #{e.backtrace}"
  end

  def vip_plan_mapping
    JSON.parse(File.read(File.expand_path('seed_files/vip_plan_mapping_seed.json', __dir__)))
  rescue StandardError => e
    puts "VIP plan mapping file error: #{e.backtrace}"
  end

  def vcp_to_vip
    JSON.parse(File.read(File.expand_path('seed_files/vcp_vip_plan_mapper_seed.json', __dir__)))
  rescue StandardError => e
    puts "VCP to VIP plan mapper file error: #{e.backtrace}"
  end

  puts '******* removing all data ... ********'
  clean_up_db
  puts '******* seeding data ... *************'

  # fake_partner
  DbService::Partner.create!(name: 'labs', root_domain: 'labs.vet')

  partner = DbService::Partner.create!(name: 'vcp', root_domain: 'vcp.vet')

  vcp_plan_mapping.each do |field, data_type|
    partner_field = DbService::PartnerField.create!(field_name: field,
                                                    field_data_type: data_type,
                                                    partner_id: partner.id)
    partner.partner_fields << partner_field
  end

  vip_plan_mapping.each do |field, data_type|
    DbService::VipField.create!(field_name: field, field_data_type: data_type)
  end

  vcp_to_vip.each do |vcp_field, vip_field|
    vip_record = DbService::VipField.where(field_name: vip_field).first
    vcp_record = DbService::PartnerField.where(field_name: vcp_field).first
    DbService::FieldMapping.create!(partner_field_id: vcp_record.id,
                                    vip_field_id: vip_record.id,
                                    translation_needed: true,
                                    mapping_document: 'wellness_plan')
  end

  partner.save!

  puts '****** data seeding done! ************'
end
