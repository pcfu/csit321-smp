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

ActiveRecord::Schema.define(version: 2021_08_07_034902) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "model_parameters", force: :cascade do |t|
    t.string "name"
    t.string "ml"
    t.integer "param_one"
    t.integer "param_two"
    t.integer "param_three"
    t.string "train_set"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "price_histories", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.date "date", null: false
    t.decimal "open"
    t.decimal "high"
    t.decimal "low"
    t.decimal "close"
    t.integer "volume"
    t.decimal "change"
    t.decimal "percent_change"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_price_histories_on_date"
    t.index ["stock_id", "date"], name: "index_price_histories_on_stock_id_and_date", unique: true
    t.index ["stock_id"], name: "index_price_histories_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "symbol", null: false
    t.string "name", null: false
    t.string "exchange", null: false
    t.string "stock_type", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_stocks_on_name"
    t.index ["symbol"], name: "index_stocks_on_symbol", unique: true
  end

  add_foreign_key "price_histories", "stocks"
end
