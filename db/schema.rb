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

ActiveRecord::Schema.define(version: 20150201092032) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "inventories", force: true do |t|
    t.integer  "item_id"
    t.decimal  "unit_price",    precision: 15, scale: 2
    t.float    "current_stock"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventories", ["item_id"], name: "index_inventories_on_item_id", using: :btree

  create_table "items", force: true do |t|
    t.string   "description"
    t.string   "part_number"
    t.decimal  "selling_price", precision: 15, scale: 2
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  create_table "receipt_details", force: true do |t|
    t.integer  "receipt_id"
    t.integer  "item_id"
    t.float    "qty"
    t.string   "unit",        limit: 5
    t.decimal  "unit_price",            precision: 15, scale: 2
    t.decimal  "total",                 precision: 15, scale: 2
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "description"
    t.string   "part_number"
  end

  add_index "receipt_details", ["item_id"], name: "index_receipt_details_on_item_id", using: :btree
  add_index "receipt_details", ["receipt_id"], name: "index_receipt_details_on_receipt_id", using: :btree

  create_table "receipts", force: true do |t|
    t.string   "receipt_number"
    t.string   "company_name",    limit: 20
    t.string   "address",         limit: 50
    t.integer  "receipt_type"
    t.decimal  "total",                      precision: 15, scale: 2
    t.decimal  "amount_received",            precision: 15, scale: 2
    t.decimal  "balance",                    precision: 15, scale: 2
    t.date     "date_issued"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  create_table "sales", force: true do |t|
    t.integer  "sales_type"
    t.integer  "inventory_id"
    t.integer  "receipt_detail_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sales", ["inventory_id"], name: "index_sales_on_inventory_id", using: :btree
  add_index "sales", ["receipt_detail_id"], name: "index_sales_on_receipt_detail_id", using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
