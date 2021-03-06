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

ActiveRecord::Schema.define(version: 20150817032730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "incoming_receipt_details", force: true do |t|
    t.integer  "incoming_receipt_id"
    t.string   "description"
    t.string   "part_number"
    t.decimal  "total",                         precision: 15, scale: 2
    t.decimal  "unit_price",                    precision: 15, scale: 2
    t.float    "qty"
    t.string   "unit",                limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "incoming_receipt_details", ["incoming_receipt_id"], name: "index_incoming_receipt_details_on_incoming_receipt_id", using: :btree

  create_table "incoming_receipts", force: true do |t|
    t.string   "receipt_number",  limit: 20
    t.string   "supplier",        limit: 50
    t.string   "address",         limit: 50
    t.datetime "date_issued"
    t.decimal  "total",                      precision: 15, scale: 2
    t.decimal  "amount_received",            precision: 15, scale: 2
    t.decimal  "balance",                    precision: 15, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: true do |t|
    t.integer  "item_id"
    t.decimal  "unit_price",                 precision: 15, scale: 2
    t.float    "current_stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "incoming_receipt_detail_id"
    t.integer  "outgoing_receipt_detail_id"
    t.float    "initial_stock"
    t.integer  "inventory_id"
  end

  add_index "inventories", ["incoming_receipt_detail_id"], name: "index_inventories_on_incoming_receipt_detail_id", using: :btree
  add_index "inventories", ["inventory_id"], name: "index_inventories_on_inventory_id", using: :btree
  add_index "inventories", ["item_id"], name: "index_inventories_on_item_id", using: :btree
  add_index "inventories", ["outgoing_receipt_detail_id"], name: "index_inventories_on_outgoing_receipt_detail_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "description"
    t.string   "part_number"
    t.decimal  "selling_price", precision: 15, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remarks"
  end

  create_table "merge_items", force: true do |t|
    t.integer  "from"
    t.integer  "to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merge_transactions", force: true do |t|
    t.integer  "merge_item_id"
    t.integer  "mergeable_id"
    t.string   "mergeable_type"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "merge_transactions", ["merge_item_id"], name: "index_merge_transactions_on_merge_item_id", using: :btree
  add_index "merge_transactions", ["mergeable_id", "mergeable_type"], name: "index_merge_transactions_on_mergeable_id_and_mergeable_type", using: :btree

  create_table "outgoing_receipt_details", force: true do |t|
    t.integer  "outgoing_receipt_id"
    t.integer  "item_id"
    t.decimal  "total",                         precision: 15, scale: 2
    t.float    "qty"
    t.string   "unit",                limit: 5
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "selling_price",                 precision: 15, scale: 2
    t.decimal  "unit_price"
  end

  add_index "outgoing_receipt_details", ["item_id"], name: "index_outgoing_receipt_details_on_item_id", using: :btree
  add_index "outgoing_receipt_details", ["outgoing_receipt_id"], name: "index_outgoing_receipt_details_on_outgoing_receipt_id", using: :btree

  create_table "outgoing_receipts", force: true do |t|
    t.string   "receipt_number",  limit: 20
    t.string   "client",          limit: 50
    t.string   "address",         limit: 50
    t.datetime "date_issued"
    t.decimal  "total",                      precision: 15, scale: 2
    t.decimal  "amount_received",            precision: 15, scale: 2
    t.decimal  "balance",                    precision: 15, scale: 2
    t.integer  "sale_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "po_no"
    t.string   "plate_no"
  end

  create_table "users", force: true do |t|
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
