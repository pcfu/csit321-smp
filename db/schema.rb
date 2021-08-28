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

ActiveRecord::Schema.define(version: 2021_08_28_173901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :model_training_stage, [
    "requested",
    "enqueued",
    "training",
    "done",
    "error",
  ], force: :cascade

  create_table "headlines", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.date "date", null: false
    t.text "title", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_headlines_on_date"
    t.index ["stock_id", "date"], name: "index_headlines_on_stock_id_and_date"
    t.index ["stock_id"], name: "index_headlines_on_stock_id"
  end

  create_table "model_configs", force: :cascade do |t|
    t.string "name", null: false
    t.text "params", null: false
    t.integer "train_percent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_model_configs_on_name", unique: true
  end

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

  create_table "model_trainings", force: :cascade do |t|
    t.bigint "model_config_id", null: false
    t.bigint "stock_id", null: false
    t.date "date_start", null: false
    t.date "date_end", null: false
    t.enum "stage", null: false, enum_name: "model_training_stage"
    t.decimal "rmse"
    t.text "error_message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["model_config_id", "stock_id"], name: "index_model_trainings_on_model_config_id_and_stock_id", unique: true
    t.index ["model_config_id"], name: "index_model_trainings_on_model_config_id"
    t.index ["stage"], name: "index_model_trainings_on_stage"
    t.index ["stock_id"], name: "index_model_trainings_on_stock_id"
  end

  create_table "price_histories", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.date "date", null: false
    t.decimal "open", null: false
    t.decimal "high", null: false
    t.decimal "low", null: false
    t.decimal "close", null: false
    t.integer "volume", null: false
    t.decimal "change", null: false
    t.decimal "percent_change", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_price_histories_on_date"
    t.index ["stock_id", "date"], name: "index_price_histories_on_stock_id_and_date", unique: true
    t.index ["stock_id"], name: "index_price_histories_on_stock_id"
  end

  create_table "price_predictions", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.date "entry_date", null: false
    t.date "nd_date", null: false
    t.decimal "nd_max_price", null: false
    t.decimal "nd_exp_price", null: false
    t.decimal "nd_min_price", null: false
    t.date "st_date", null: false
    t.decimal "st_max_price", null: false
    t.decimal "st_exp_price", null: false
    t.decimal "st_min_price", null: false
    t.date "mt_date", null: false
    t.decimal "mt_max_price", null: false
    t.decimal "mt_exp_price", null: false
    t.decimal "mt_min_price", null: false
    t.date "lt_date", null: false
    t.decimal "lt_max_price", null: false
    t.decimal "lt_exp_price", null: false
    t.decimal "lt_min_price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id", "entry_date"], name: "index_price_predictions_on_stock_id_and_entry_date"
    t.index ["stock_id"], name: "index_price_predictions_on_stock_id"
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

  add_foreign_key "headlines", "stocks"
  add_foreign_key "model_trainings", "model_configs"
  add_foreign_key "model_trainings", "stocks"
  add_foreign_key "price_histories", "stocks"
  add_foreign_key "price_predictions", "stocks"
end
