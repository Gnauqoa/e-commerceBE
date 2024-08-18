# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_14_055903) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "classes", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coaches", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "phone"
    t.datetime "birth"
    t.integer "status"
    t.string "description"
    t.string "email"
    t.string "username"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lessons", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "points"
    t.string "code"
    t.string "user_notes"
    t.string "coach_notes"
    t.string "material_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "class_id"
    t.index ["class_id"], name: "index_lessons_on_class_id"
  end

  create_table "user_classes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "class_id"
    t.index ["class_id"], name: "index_user_classes_on_class_id"
    t.index ["user_id"], name: "index_user_classes_on_user_id"
  end

  create_table "user_lessons", force: :cascade do |t|
    t.integer "points"
    t.integer "status"
    t.string "submit_url"
    t.string "coach_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "lesson_id"
    t.bigint "coach_id"
    t.index ["coach_id"], name: "index_user_lessons_on_coach_id"
    t.index ["lesson_id"], name: "index_user_lessons_on_lesson_id"
    t.index ["user_id"], name: "index_user_lessons_on_user_id"
  end

  create_table "user_point_records", force: :cascade do |t|
    t.integer "points"
    t.integer "type"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "user_lesson_id"
    t.index ["user_id"], name: "index_user_point_records_on_user_id"
    t.index ["user_lesson_id"], name: "index_user_point_records_on_user_lesson_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "username"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone"
    t.date "birth"
    t.integer "status"
  end

  add_foreign_key "lessons", "classes"
  add_foreign_key "user_classes", "classes"
  add_foreign_key "user_classes", "users"
  add_foreign_key "user_lessons", "coaches"
  add_foreign_key "user_lessons", "lessons"
  add_foreign_key "user_lessons", "users"
  add_foreign_key "user_point_records", "user_lessons"
  add_foreign_key "user_point_records", "users"
end
