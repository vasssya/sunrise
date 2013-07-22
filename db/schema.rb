# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130722154131) do

  create_table "accounts", force: true do |t|
    t.string   "currency"
    t.decimal  "amount",     precision: 12, scale: 4, default: 0.0, null: false
    t.decimal  "reserved",   precision: 12, scale: 4, default: 0.0, null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "bids", force: true do |t|
    t.string   "buy_currency"
    t.string   "sell_currency"
    t.decimal  "amount"
    t.decimal  "max_price"
    t.decimal  "rate"
    t.decimal  "reverse_rate"
    t.string   "state",         default: "new", null: false
    t.text     "info",          default: "",    null: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bids", ["user_id"], name: "index_bids_on_user_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.integer  "bids",       array: true
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["from_id"], name: "index_transactions_on_from_id", using: :btree
  add_index "transactions", ["to_id"], name: "index_transactions_on_to_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
