# This migration comes from db_service (originally 20191216130142)
class PgcryptoExt < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'
  end
end
