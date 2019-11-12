# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_12_185213) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "db_service_endpoints", force: :cascade do |t|
    t.integer "partner_id"
    t.string "endpoint_name"
    t.string "protocol"
    t.string "subdomain"
    t.string "api_route"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["partner_id"], name: "index_db_service_endpoints_on_partner_id"
  end

  create_table "db_service_partner_fields", force: :cascade do |t|
    t.integer "partner_id"
    t.string "field_name"
    t.string "field_data_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["partner_id"], name: "index_db_service_partner_fields_on_partner_id"
  end

  create_table "db_service_partners", force: :cascade do |t|
    t.string "name"
    t.string "root_domain"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "db_service_vip_fields", force: :cascade do |t|
    t.string "field_name"
    t.string "field_data_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
