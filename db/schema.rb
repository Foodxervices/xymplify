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

ActiveRecord::Schema.define(version: 20170807033905) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "food_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["food_item_id"], name: "index_attachments_on_food_item_id", using: :btree
  add_index "attachments", ["restaurant_id"], name: "index_attachments_on_restaurant_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string  "name"
    t.integer "priority", default: 1
  end

  add_index "categories", ["priority"], name: "index_categories_on_priority", using: :btree

  create_table "configs", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "value"
  end

  add_index "configs", ["slug"], name: "index_configs_on_slug", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "designation"
    t.string "organisation"
    t.text   "your_query"
  end

  create_table "dish_items", force: :cascade do |t|
    t.integer  "food_item_id"
    t.integer  "dish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "quantity",     precision: 8, scale: 2, default: 0.0
    t.string   "unit"
    t.float    "unit_rate"
  end

  add_index "dish_items", ["dish_id"], name: "index_dish_items_on_dish_id", using: :btree
  add_index "dish_items", ["food_item_id"], name: "index_dish_items_on_food_item_id", using: :btree

  create_table "dish_requisition_items", force: :cascade do |t|
    t.integer "dish_requisition_id"
    t.integer "dish_id"
    t.decimal "quantity",            precision: 8, scale: 2, default: 0.0
    t.integer "unit_price_cents",                            default: 0,     null: false
    t.string  "unit_price_currency",                         default: "SGD", null: false
  end

  add_index "dish_requisition_items", ["dish_id"], name: "index_dish_requisition_items_on_dish_id", using: :btree
  add_index "dish_requisition_items", ["dish_requisition_id"], name: "index_dish_requisition_items_on_dish_requisition_id", using: :btree

  create_table "dish_requisitions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "kitchen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price_cents",    default: 0,     null: false
    t.string   "price_currency", default: "SGD", null: false
  end

  add_index "dish_requisitions", ["kitchen_id"], name: "index_dish_requisitions_on_kitchen_id", using: :btree
  add_index "dish_requisitions", ["user_id"], name: "index_dish_requisitions_on_user_id", using: :btree

  create_table "dishes", force: :cascade do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profit_margin_cents",    default: 0,     null: false
    t.string   "profit_margin_currency", default: "SGD", null: false
    t.datetime "deleted_at"
  end

  add_index "dishes", ["deleted_at"], name: "index_dishes_on_deleted_at", using: :btree
  add_index "dishes", ["restaurant_id"], name: "index_dishes_on_restaurant_id", using: :btree
  add_index "dishes", ["user_id"], name: "index_dishes_on_user_id", using: :btree

  create_table "food_items", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "unit"
    t.integer  "supplier_id"
    t.integer  "user_id"
    t.string   "brand"
    t.integer  "unit_price_cents",                                              default: 0,                     null: false
    t.string   "unit_price_currency",                                                                           null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "restaurant_id"
    t.integer  "category_id"
    t.string   "cached_tag_list",                                               default: ""
    t.decimal  "low_quantity",                          precision: 8, scale: 2
    t.integer  "unit_price_without_promotion_cents",                            default: 0,                     null: false
    t.string   "unit_price_without_promotion_currency",                         default: "SGD",                 null: false
    t.integer  "attachments_count",                                             default: 0
    t.datetime "deleted_at"
    t.integer  "ordered_count",                                                 default: 0
    t.string   "country_of_origin"
    t.text     "remarks"
    t.datetime "created_at",                                                    default: '2017-08-01 07:55:16', null: false
    t.datetime "updated_at",                                                    default: '2017-08-01 07:55:16', null: false
  end

  add_index "food_items", ["category_id"], name: "index_food_items_on_category_id", using: :btree
  add_index "food_items", ["code"], name: "index_food_items_on_code", using: :btree
  add_index "food_items", ["deleted_at"], name: "index_food_items_on_deleted_at", using: :btree
  add_index "food_items", ["ordered_count"], name: "index_food_items_on_ordered_count", using: :btree
  add_index "food_items", ["restaurant_id"], name: "index_food_items_on_restaurant_id", using: :btree
  add_index "food_items", ["supplier_id"], name: "index_food_items_on_supplier_id", using: :btree
  add_index "food_items", ["user_id"], name: "index_food_items_on_user_id", using: :btree

  create_table "food_items_kitchens", force: :cascade do |t|
    t.integer "food_item_id"
    t.integer "kitchen_id"
  end

  create_table "inventories", force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "kitchen_id"
    t.integer "food_item_id"
    t.decimal "current_quantity", precision: 8, scale: 2, default: 0.0
    t.decimal "quantity_ordered", precision: 8, scale: 2, default: 0.0
  end

  add_index "inventories", ["food_item_id"], name: "index_inventories_on_food_item_id", using: :btree
  add_index "inventories", ["kitchen_id"], name: "index_inventories_on_kitchen_id", using: :btree
  add_index "inventories", ["restaurant_id"], name: "index_inventories_on_restaurant_id", using: :btree

  create_table "kitchens", force: :cascade do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.string   "bank_name"
    t.string   "bank_address"
    t.string   "bank_swift_code"
    t.string   "bank_account_name"
    t.string   "bank_account_number"
    t.string   "address"
    t.string   "phone"
    t.datetime "deleted_at"
  end

  add_index "kitchens", ["deleted_at"], name: "index_kitchens_on_deleted_at", using: :btree
  add_index "kitchens", ["restaurant_id"], name: "index_kitchens_on_restaurant_id", using: :btree

  create_table "kitchens_suppliers", force: :cascade do |t|
    t.integer "supplier_id"
    t.integer "kitchen_id"
  end

  add_index "kitchens_suppliers", ["kitchen_id"], name: "index_kitchens_suppliers_on_kitchen_id", using: :btree
  add_index "kitchens_suppliers", ["supplier_id"], name: "index_kitchens_suppliers_on_supplier_id", using: :btree

  create_table "kitchens_user_roles", force: :cascade do |t|
    t.integer "kitchen_id"
    t.integer "user_role_id"
  end

  add_index "kitchens_user_roles", ["kitchen_id"], name: "index_kitchens_user_roles_on_kitchen_id", using: :btree
  add_index "kitchens_user_roles", ["user_role_id"], name: "index_kitchens_user_roles_on_user_role_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "restaurant_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kitchen_id"
  end

  add_index "messages", ["kitchen_id"], name: "index_messages_on_kitchen_id", using: :btree
  add_index "messages", ["restaurant_id"], name: "index_messages_on_restaurant_id", using: :btree

  create_table "order_gsts", force: :cascade do |t|
    t.string  "name",                                  default: ""
    t.decimal "percent",       precision: 4, scale: 2, default: 0.0
    t.integer "order_id"
    t.integer "restaurant_id"
    t.integer "kitchen_id"
  end

  add_index "order_gsts", ["kitchen_id"], name: "index_order_gsts_on_kitchen_id", using: :btree
  add_index "order_gsts", ["order_id"], name: "index_order_gsts_on_order_id", using: :btree
  add_index "order_gsts", ["restaurant_id"], name: "index_order_gsts_on_restaurant_id", using: :btree

  create_table "order_items", force: :cascade do |t|
    t.integer "unit_price_cents",                                              default: 0,     null: false
    t.string  "unit_price_currency",                                           default: "SGD", null: false
    t.decimal "quantity",                              precision: 8, scale: 2, default: 0.0
    t.integer "order_id"
    t.integer "food_item_id"
    t.integer "restaurant_id"
    t.string  "name"
    t.integer "category_id"
    t.integer "unit_price_without_promotion_cents",                            default: 0,     null: false
    t.string  "unit_price_without_promotion_currency",                         default: "SGD", null: false
    t.integer "kitchen_id"
  end

  add_index "order_items", ["category_id"], name: "index_order_items_on_category_id", using: :btree
  add_index "order_items", ["food_item_id"], name: "index_order_items_on_food_item_id", using: :btree
  add_index "order_items", ["kitchen_id"], name: "index_order_items_on_kitchen_id", using: :btree
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
    t.datetime "delivered_at"
    t.string   "name"
    t.integer  "gsts_count",              default: 0
    t.datetime "placed_at"
    t.datetime "status_updated_at"
    t.datetime "accepted_at"
    t.datetime "declined_at"
    t.datetime "cancelled_at"
    t.string   "token"
    t.integer  "price_cents",             default: 0,     null: false
    t.string   "price_currency",          default: "SGD", null: false
    t.string   "outlet_name"
    t.string   "outlet_address"
    t.string   "outlet_phone"
    t.boolean  "delivered_to_kitchen",    default: true
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer  "paid_amount_cents",       default: 0,     null: false
    t.string   "paid_amount_currency",    default: "SGD", null: false
    t.integer  "gst_cents",               default: 0,     null: false
    t.string   "gst_currency",            default: "SGD", null: false
    t.date     "request_delivery_date"
    t.string   "start_time"
    t.string   "end_time"
    t.text     "eatery_remarks"
    t.datetime "pending_at"
    t.datetime "rejected_at"
  end

  add_index "orders", ["kitchen_id"], name: "index_orders_on_kitchen_id", using: :btree
  add_index "orders", ["restaurant_id"], name: "index_orders_on_restaurant_id", using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["supplier_id"], name: "index_orders_on_supplier_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "payment_histories", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "pay_amount_cents",            default: 0,     null: false
    t.string   "pay_amount_currency",         default: "SGD", null: false
    t.integer  "outstanding_amount_cents",    default: 0,     null: false
    t.string   "outstanding_amount_currency", default: "SGD", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payment_histories", ["order_id"], name: "index_payment_histories_on_order_id", using: :btree

  create_table "requisition_items", force: :cascade do |t|
    t.integer "requisition_id"
    t.integer "food_item_id"
    t.decimal "quantity",            precision: 8, scale: 2, default: 0.0
    t.integer "unit_price_cents",                            default: 0,     null: false
    t.string  "unit_price_currency",                         default: "SGD", null: false
  end

  add_index "requisition_items", ["food_item_id"], name: "index_requisition_items_on_food_item_id", using: :btree
  add_index "requisition_items", ["requisition_id"], name: "index_requisition_items_on_requisition_id", using: :btree

  create_table "requisitions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "kitchen_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requisitions", ["kitchen_id"], name: "index_requisitions_on_kitchen_id", using: :btree
  add_index "requisitions", ["user_id"], name: "index_requisitions_on_user_id", using: :btree

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
    t.datetime "deleted_at"
    t.text     "block_delivery_dates"
    t.string   "receive_email"
  end

  add_index "restaurants", ["deleted_at"], name: "index_restaurants_on_deleted_at", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "permissions"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "country"
    t.string   "contact"
    t.string   "telephone"
    t.string   "email"
    t.string   "currency",                                         default: "SGD"
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
    t.integer  "priority"
    t.decimal  "min_order_price",         precision: 12, scale: 2, default: 0.0
    t.decimal  "max_order_price",         precision: 12, scale: 2
    t.string   "delivery_days"
    t.time     "processing_cut_off"
    t.text     "block_delivery_dates"
    t.string   "cc_emails",                                        default: ""
    t.text     "remarks"
    t.datetime "created_at",                                       default: '2017-08-01 07:56:38', null: false
    t.datetime "updated_at",                                       default: '2017-08-01 07:56:38', null: false
  end

  add_index "suppliers", ["priority"], name: "index_suppliers_on_priority", using: :btree
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
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "type"
    t.string   "name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "receive_email",          default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",      null: false
    t.integer  "item_id",        null: false
    t.string   "event",          null: false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  add_index "versions", ["whodunnit"], name: "index_versions_on_whodunnit", using: :btree

end
