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

ActiveRecord::Schema.define(:version => 20120926002408) do

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

  add_index "product_invoices", ["product_id"], :name => "index_product_invoices_on_product_id"
  add_index "product_invoices", ["user_id"], :name => "index_product_invoices_on_user_id"

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
  add_index "transactions", ["owner_id"], :name => "index_transactions_on_owner_id"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.integer  "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "avatar"
    t.integer  "money",                   :limit => 8
    t.datetime "created_at",                                              :null => false
    t.datetime "updated_at",                                              :null => false
    t.integer  "shares"
    t.integer  "retention_shares"
    t.integer  "share_price",             :limit => 8
    t.datetime "last_update"
    t.integer  "base_price"
    t.integer  "hour_delta_price"
    t.boolean  "is_admin",                             :default => false
    t.string   "token"
    t.string   "secret"
    t.boolean  "acivated",                             :default => false
    t.string   "locale",                               :default => "en"
    t.boolean  "twitter_translation",                  :default => true
    t.integer  "tweets_num",                           :default => 0
    t.integer  "retweets_num",                         :default => 0
    t.integer  "followers_num",                        :default => 0
    t.integer  "pop",                                  :default => 0
    t.text     "best_tweet_text"
    t.integer  "best_tweet_retweets_num",              :default => -1
    t.datetime "best_updated"
    t.float    "best_tweet_param",                     :default => 0.0
    t.string   "best_tweet_id"
    t.string   "best_tweet_media_url"
  end

  add_index "users", ["best_tweet_retweets_num"], :name => "index_users_on_best_tweet_retweets_num"
  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end
