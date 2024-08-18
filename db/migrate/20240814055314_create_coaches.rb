class CreateCoaches < ActiveRecord::Migration[7.1]
  def change
    create_table :coaches do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "phone"
      t.datetime "birth"
      t.integer "status"
      t.string "description"
      ## Database authenticatable
      t.string "email"
      t.string "username"
      t.string "encrypted_password", default: "", null: false
      ## Recoverable
      t.string "reset_password_token"
      t.datetime "reset_password_sent_at", precision: nil
      ## Rememberable
      t.datetime "remember_created_at", precision: nil
      ## Trackable
      t.integer "sign_in_count"
      t.datetime "current_sign_in_at"
      t.datetime "last_sign_in_at"
      t.string "current_sign_in_ip"
      t.string "last_sign_in_ip"

      t.timestamps
    end
  end
end
