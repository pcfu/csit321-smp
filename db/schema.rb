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

ActiveRecord::Schema.define(version: 2021_11_12_134025) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :ml_name, [
    "lstm",
    "svm",
    "rf",
  ], force: :cascade

  create_enum :model_training_stage, [
    "requested",
    "enqueued",
    "training",
    "done",
    "error",
  ], force: :cascade

  create_enum :recommendation_verdict, [
    "buy",
    "hold",
    "sell",
  ], force: :cascade

  create_enum :stock_industry, [
    "technology",
    "energy",
    "healthcare",
  ], force: :cascade

  create_enum :user_role, [
    "regular",
    "admin",
    "banned",
  ], force: :cascade

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id"], name: "index_favorites_on_stock_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "model_configs", force: :cascade do |t|
    t.string "name", null: false
    t.text "params", null: false
    t.integer "train_percent", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "active"
    t.enum "model_type", enum_name: "ml_name"
    t.index ["name"], name: "index_model_configs_on_name", unique: true
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
    t.decimal "accuracy"
    t.text "parameters"
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
    t.bigint "volume", null: false
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
    t.date "reference_date", null: false
    t.date "st_date", null: false
    t.decimal "st_exp_price", null: false
    t.date "mt_date", null: false
    t.decimal "mt_exp_price", null: false
    t.date "lt_date", null: false
    t.decimal "lt_exp_price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["stock_id", "reference_date"], name: "index_price_predictions_on_stock_id_and_reference_date"
    t.index ["stock_id"], name: "index_price_predictions_on_stock_id"
  end

  create_table "recommendations", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "prediction_date", null: false
    t.enum "verdict", enum_name: "recommendation_verdict"
    t.index ["stock_id", "prediction_date"], name: "index_recommendations_on_stock_id_and_prediction_date"
    t.index ["stock_id"], name: "index_recommendations_on_stock_id"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "symbol", null: false
    t.string "name", null: false
    t.string "exchange", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.enum "industry", enum_name: "stock_industry"
    t.index ["name"], name: "index_stocks_on_name"
    t.index ["symbol"], name: "index_stocks_on_symbol", unique: true
  end

  create_table "technical_indicators", force: :cascade do |t|
    t.bigint "stock_id", null: false
    t.date "date", null: false
    t.decimal "sma_5"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "sma_8"
    t.decimal "sma_10"
    t.decimal "wma_5"
    t.decimal "wma_8"
    t.decimal "wma_10"
    t.decimal "macd"
    t.decimal "cci"
    t.decimal "stoch_k"
    t.decimal "stoch_d"
    t.decimal "williams"
    t.decimal "rsi"
    t.decimal "roc"
    t.decimal "ad"
    t.decimal "atr"
    t.index ["date"], name: "index_technical_indicators_on_date"
    t.index ["stock_id", "date"], name: "index_technical_indicators_on_stock_id_and_date", unique: true
    t.index ["stock_id"], name: "index_technical_indicators_on_stock_id"
  end

  create_table "thresholds", force: :cascade do |t|
    t.bigint "favorite_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.decimal "buythreshold"
    t.decimal "sellthreshold"
    t.index ["favorite_id"], name: "index_thresholds_on_favorite_id"
  end

  create_table "training_schedules", force: :cascade do |t|
    t.bigint "model_config_id", null: false
    t.date "start_date"
    t.integer "frequency"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["model_config_id"], name: "index_training_schedules_on_model_config_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.enum "role", null: false, enum_name: "user_role"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "favorites", "stocks"
  add_foreign_key "favorites", "users"
  add_foreign_key "model_trainings", "model_configs"
  add_foreign_key "model_trainings", "stocks"
  add_foreign_key "price_histories", "stocks"
  add_foreign_key "price_predictions", "stocks"
  add_foreign_key "recommendations", "stocks"
  add_foreign_key "technical_indicators", "stocks"
  add_foreign_key "thresholds", "favorites"
  add_foreign_key "training_schedules", "model_configs"
end
