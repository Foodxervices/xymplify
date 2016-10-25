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

ActiveRecord::Schema.define(version: 20161025090823) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alerts", force: :cascade do |t|
    t.string   "title"
    t.integer  "alertable_id"
    t.string   "alertable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alerts", ["alertable_type", "alertable_id"], name: "index_alerts_on_alertable_type_and_alertable_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string "name"
  end

  create_table "food_items", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "unit"
    t.integer  "supplier_id"
    t.integer  "user_id"
    t.decimal  "current_quantity",    precision: 8, scale: 2, default: 0.0
    t.decimal  "quantity_ordered",    precision: 8, scale: 2, default: 0.0
    t.string   "brand"
    t.integer  "unit_price_cents",                            default: 0,   null: false
    t.string   "unit_price_currency",                                       null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "kitchen_id"
    t.integer  "restaurant_id"
    t.integer  "category_id"
    t.string   "cached_tag_list",                             default: ""
    t.decimal  "low_quantity",        precision: 8, scale: 2
  end

  add_index "food_items", ["category_id"], name: "index_food_items_on_category_id", using: :btree
  add_index "food_items", ["kitchen_id"], name: "index_food_items_on_kitchen_id", using: :btree
  add_index "food_items", ["restaurant_id"], name: "index_food_items_on_restaurant_id", using: :btree
  add_index "food_items", ["supplier_id"], name: "index_food_items_on_supplier_id", using: :btree
  add_index "food_items", ["user_id"], name: "index_food_items_on_user_id", using: :btree

  create_table "kitchens", force: :cascade do |t|
    t.string  "name"
    t.integer "restaurant_id"
    t.string  "bank_name"
    t.string  "bank_address"
    t.string  "bank_swift_code"
    t.string  "bank_account_name"
    t.string  "bank_account_number"
    t.string  "address"
    t.string  "phone"
  end

  add_index "kitchens", ["restaurant_id"], name: "index_kitchens_on_restaurant_id", using: :btree

  create_table "kitchens_user_roles", force: :cascade do |t|
    t.integer "kitchen_id"
    t.integer "user_role_id"
  end

  add_index "kitchens_user_roles", ["kitchen_id"], name: "index_kitchens_user_roles_on_kitchen_id", using: :btree
  add_index "kitchens_user_roles", ["user_role_id"], name: "index_kitchens_user_roles_on_user_role_id", using: :btree

  create_table "order_gsts", force: :cascade do |t|
    t.string  "name",                                    default: "GST"
    t.decimal "percent",         precision: 4, scale: 2, default: 0.0
    t.integer "amount_cents",                            default: 0,     null: false
    t.string  "amount_currency",                         default: "SGD", null: false
    t.integer "order_id"
    t.integer "restaurant_id"
  end

  add_index "order_gsts", ["order_id"], name: "index_order_gsts_on_order_id", using: :btree
  add_index "order_gsts", ["restaurant_id"], name: "index_order_gsts_on_restaurant_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer "unit_price_cents",                            default: 0,     null: false
    t.string  "unit_price_currency",                         default: "SGD", null: false
    t.decimal "quantity",            precision: 8, scale: 2, default: 0.0
    t.integer "order_id"
    t.integer "food_item_id"
    t.integer "restaurant_id"
    t.string  "name"
  end

  add_index "order_items", ["food_item_id"], name: "index_order_items_on_food_item_id", using: :btree
  add_index "order_items", ["order_id"], name: "index_order_items_on_order_id", using: :btree
  add_index "order_items", ["restaurant_id"], name: "index_order_items_on_restaurant_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "supplier_id"
    t.integer  "kitchen_id"
    t.integer  "user_id"
    t.string   "status"
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "delivery_at"
    t.string   "name"
    t.integer  "gsts_count",        default: 0
    t.datetime "placed_at"
    t.datetime "status_updated_at"
  end

  add_index "orders", ["kitchen_id"], name: "index_orders_on_kitchen_id", using: :btree
  add_index "orders", ["restaurant_id"], name: "index_orders_on_restaurant_id", using: :btree
  add_index "orders", ["supplier_id"], name: "index_orders_on_supplier_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.string   "site_address"
    t.string   "billing_address"
    t.string   "contact_person"
    t.string   "telephone"
    t.string   "email"
    t.string   "currency",                default: "SGD"
    t.string   "company_registration_no"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "permissions"
  end

  create_table "seens", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.datetime "at"
  end

  add_index "seens", ["restaurant_id"], name: "index_seens_on_restaurant_id", using: :btree
  add_index "seens", ["user_id"], name: "index_seens_on_user_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "country"
    t.string   "contact"
    t.string   "telephone"
    t.string   "email"
    t.string   "currency",                default: "SGD"
    t.integer  "restaurant_id"
    t.string   "bank_name"
    t.string   "bank_address"
    t.string   "bank_swift_code"
    t.string   "bank_account_name"
    t.string   "bank_account_number"
    t.string   "company_registration_no"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
  end

  add_index "suppliers", ["restaurant_id"], name: "index_suppliers_on_restaurant_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["context"], name: "index_taggings_on_context", using: :btree
  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
  add_index "taggings", ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
  add_index "taggings", ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
  add_index "taggings", ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
  add_index "taggings", ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "user_roles", force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "user_id"
    t.integer "role_id"
    t.integer "kitchens_count", default: 0
  end

  add_index "user_roles", ["restaurant_id"], name: "index_user_roles_on_restaurant_id", using: :btree
  add_index "user_roles", ["role_id"], name: "index_user_roles_on_role_id", using: :btree
  add_index "user_roles", ["user_id"], name: "index_user_roles_on_user_id", using: :btree

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
    t.string   "name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
