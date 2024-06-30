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

ActiveRecord::Schema[7.1].define(version: 2024_06_29_210652) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer "category_type", null: false
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "financial_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.text "description"
    t.float "initial_amount", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_financial_accounts_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "transaction_type", null: false
    t.bigint "user_id", null: false
    t.bigint "category_id"
    t.bigint "from_financial_account_id"
    t.bigint "to_financial_account_id"
    t.datetime "date", null: false
    t.float "amount", default: 0.0
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "financial_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["financial_account_id"], name: "index_transactions_on_financial_account_id"
    t.index ["from_financial_account_id"], name: "index_transactions_on_from_financial_account_id"
    t.index ["to_financial_account_id"], name: "index_transactions_on_to_financial_account_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_active_session_keys", primary_key: ["user_id", "session_id"], force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "session_id", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "last_use", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_user_active_session_keys_on_user_id"
  end

  create_table "user_identities", force: :cascade do |t|
    t.bigint "user_id"
    t.string "provider", null: false
    t.string "uid", null: false
    t.index ["provider", "uid"], name: "index_user_identities_on_provider_and_uid", unique: true
    t.index ["user_id"], name: "index_user_identities_on_user_id"
  end

  create_table "user_login_change_keys", force: :cascade do |t|
    t.string "key", null: false
    t.string "login", null: false
    t.datetime "deadline", null: false
  end

  create_table "user_password_reset_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "deadline", null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "user_verification_keys", force: :cascade do |t|
    t.string "key", null: false
    t.datetime "requested_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "email_last_sent", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "status", default: 1, null: false
    t.citext "email", null: false
    t.string "password_hash"
    t.index ["email"], name: "index_users_on_email", unique: true, where: "(status = ANY (ARRAY[1, 2]))"
  end

  add_foreign_key "categories", "users"
  add_foreign_key "financial_accounts", "users"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "financial_accounts"
  add_foreign_key "transactions", "financial_accounts", column: "from_financial_account_id"
  add_foreign_key "transactions", "financial_accounts", column: "to_financial_account_id"
  add_foreign_key "transactions", "users"
  add_foreign_key "user_active_session_keys", "users"
  add_foreign_key "user_identities", "users", on_delete: :cascade
  add_foreign_key "user_login_change_keys", "users", column: "id"
  add_foreign_key "user_password_reset_keys", "users", column: "id"
  add_foreign_key "user_verification_keys", "users", column: "id"
end
