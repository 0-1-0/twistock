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

ActiveRecord::Schema.define(:version => 20120423201625) do

  create_table "block_of_shares", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "holder_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "block_of_shares", ["holder_id"], :name => "index_block_of_shares_on_holder_id"
  add_index "block_of_shares", ["owner_id"], :name => "index_block_of_shares_on_owner_id"

  create_table "transactions", :force => true do |t|
    t.integer  "user_id"
    t.string   "action"
    t.integer  "owner_id"
    t.integer  "count"
    t.integer  "cost"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "transactions", ["action"], :name => "index_transactions_on_action"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "avatar"
    t.integer  "money"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "shares"
    t.integer  "retention_shares"
    t.integer  "share_price"
  end

  add_index "users", ["name"], :name => "index_users_on_name", :unique => true
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end