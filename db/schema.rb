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

ActiveRecord::Schema[7.2].define(version: 2026_09_14_000005) do
  create_table "credit_accounts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.integer "credit_limit_cents", null: false
    t.integer "balance_cents", default: 0, null: false
    t.date "opened_on", null: false
    t.string "status", default: "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_accounts_on_user_id"
  end

  create_table "disputes", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "bureau", null: false
    t.string "item_description", null: false
    t.string "reason", null: false
    t.string "status", default: "draft", null: false
    t.text "letter_body"
    t.text "resolution_notes"
    t.date "submitted_on"
    t.date "resolved_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_disputes_on_status"
    t.index ["user_id"], name: "index_disputes_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "credit_account_id", null: false
    t.integer "amount_cents", null: false
    t.date "due_on", null: false
    t.date "paid_on"
    t.string "status", default: "scheduled", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_account_id", "due_on"], name: "index_payments_on_credit_account_id_and_due_on"
    t.index ["credit_account_id"], name: "index_payments_on_credit_account_id"
  end

  create_table "score_entries", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "score", null: false
    t.date "recorded_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "recorded_on"], name: "index_score_entries_on_user_id_and_recorded_on", unique: true
    t.index ["user_id"], name: "index_score_entries_on_user_id"
  end

  create_table "score_goals", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "target_score", null: false
    t.date "target_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_score_goals_on_user_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "credit_accounts", "users"
  add_foreign_key "disputes", "users"
  add_foreign_key "payments", "credit_accounts"
  add_foreign_key "score_entries", "users"
  add_foreign_key "score_goals", "users"
end
