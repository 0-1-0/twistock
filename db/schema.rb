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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120909182901) do

  create_table "block_of_shares", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "holder_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "block_of_shares", ["holder_id"], :name => "index_block_of_shares_on_holder_id"
  add_index "block_of_shares", ["owner_id"], :name => "index_block_of_shares_on_owner_id"

  create_table "main_page_streams", :force => true do |t|
    t.string   "eng_name"
    t.string   "ru_name"
    t.text     "list_of_users"
    t.string   "eng_tooltip"
    t.string   "tu_tooltip"
    t.integer  "priority",      :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "price_stamps", :force => true do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "previous_price"
    t.integer  "delta"
  end

  add_index "price_stamps", ["user_id"], :name => "index_price_stamps_on_user_id"

  create_table "product_invoices", :force => true do |t|
    t.string   "product"
    t.string   "country"
    t.string   "postal_code"
    t.string   "city"
    t.string   "full_name"
    t.string   "address"
    t.string   "email"
    t.string   "phone"
    t.integer  "total_cost"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "product_id"
    t.integer  "user_id"
    t.string   "status"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "price"
    t.text     "short_description", :default => "0"
    t.integer  "priority",          :default => 0
  end

  create_table "transactions", :force => true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "owner_id"
    t.integer  "count"
    t.integer  "cost"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "price",      :default => 0
  end

  add_index "transactions", ["action"], :name => "index_transactions_on_action"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "avatar"
    t.integer  "money",            :limit => 8
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "shares"
    t.integer  "retention_shares"
    t.integer  "share_price",      :limit => 8
    t.datetime "last_update"
    t.integer  "base_price"
    t.integer  "hour_delta_price"
    t.boolean  "is_admin",                      :default => false
    t.string   "token"
    t.string   "secret"
    t.boolean  "acivated",                      :default => false
    t.string   "locale",                        :default => "en"
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end
