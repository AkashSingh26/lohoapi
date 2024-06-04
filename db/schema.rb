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

ActiveRecord::Schema[7.1].define(version: 2024_06_04_143612) do
  create_table "calendar_entries", force: :cascade do |t|
    t.integer "villa_id", null: false
    t.date "date"
    t.decimal "price"
    t.boolean "available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["villa_id"], name: "index_calendar_entries_on_villa_id"
  end

  create_table "villas", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "guest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "calendar_entries", "villas"
end
