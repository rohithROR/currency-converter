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

ActiveRecord::Schema[7.0].define(version: 2025_07_12_132958) do
  create_table "conversions", force: :cascade do |t|
    t.string "source_currency", null: false
    t.string "target_currency", null: false
    t.decimal "source_amount", precision: 16, scale: 4, null: false
    t.decimal "target_amount", precision: 16, scale: 4, null: false
    t.decimal "rate", precision: 16, scale: 8, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_at"], name: "index_conversions_on_created_at"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "source_currency", null: false
    t.string "target_currency", null: false
    t.decimal "rate", precision: 16, scale: 8, null: false
    t.datetime "expires_at", precision: nil, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["source_currency", "target_currency"], name: "index_exchange_rates_on_source_currency_and_target_currency"
  end

end
