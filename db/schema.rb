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

ActiveRecord::Schema.define(version: 20160912045039) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "food_items", force: :cascade do |t|
    t.string  "name"
    t.string  "code"
    t.string  "unit"
    t.integer "supplier_id"
    t.integer "user_id"
    t.integer "current_quantity",    default: 0
    t.integer "quantity_ordered",    default: 0
    t.integer "brand_id"
    t.string  "brand"
    t.integer "unit_price_cents",    default: 0,     null: false
    t.string  "unit_price_currency", default: "SGD", null: false
  end

  add_index "food_items", ["brand_id"], name: "index_food_items_on_brand_id", using: :btree
  add_index "food_items", ["supplier_id"], name: "index_food_items_on_supplier_id", using: :btree
  add_index "food_items", ["user_id"], name: "index_food_items_on_user_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "country"
    t.string "contact"
    t.string "telephone"
    t.string "email"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
