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

ActiveRecord::Schema[7.0].define(version: 2023_08_04_173112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_reports", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.integer "incomes_cents", default: 0, null: false
    t.integer "expenses_cents", default: 0, null: false
    t.integer "invested_cents", default: 0, null: false
    t.integer "final_balance_cents", default: 0, null: false
    t.integer "dividends_cents", default: 0, null: false
    t.integer "total_balance_cents", default: 0, null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_account_reports_on_account_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.integer "balance_cents", default: 0, null: false
    t.integer "kind", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "user_id"], name: "index_accounts_on_name_and_user_id", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "dividends", force: :cascade do |t|
    t.datetime "date"
    t.integer "value_cents", default: 0, null: false
    t.bigint "stock_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_id"], name: "index_dividends_on_stock_id"
  end

  create_table "negotiations", force: :cascade do |t|
    t.string "kind"
    t.date "date"
    t.integer "invested_cents", default: 0
    t.integer "shares", default: 0
    t.string "negotiable_type"
    t.bigint "negotiable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["negotiable_type", "negotiable_id"], name: "index_negotiations_on_negotiable"
  end

  create_table "prices", force: :cascade do |t|
    t.date "date"
    t.integer "value_cents", default: 0
    t.string "priceable_type"
    t.bigint "priceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priceable_type", "priceable_id"], name: "index_prices_on_priceable"
  end

  create_table "stocks", force: :cascade do |t|
    t.string "ticker", null: false
    t.integer "invested_value_cents", default: 0, null: false
    t.integer "current_value_cents", default: 0, null: false
    t.integer "current_total_value_cents", default: 0, null: false
    t.integer "shares_total", default: 0
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_stocks_on_account_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "category_id"
    t.integer "value_cents", default: 0, null: false
    t.integer "kind", default: 0, null: false
    t.string "title", null: false
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
  end

  create_table "transferences", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.bigint "user_id", null: false
    t.date "date"
    t.integer "value_cents", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_transferences_on_receiver_id"
    t.index ["sender_id"], name: "index_transferences_on_sender_id"
    t.index ["user_id"], name: "index_transferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "username", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "account_reports", "accounts"
  add_foreign_key "accounts", "users"
  add_foreign_key "categories", "users"
  add_foreign_key "dividends", "stocks"
  add_foreign_key "stocks", "accounts"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transferences", "users"
end
