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

ActiveRecord::Schema.define(:version => 20121122113007) do

  create_table "best_tweets", :force => true do |t|
    t.integer  "user_id"
    t.string   "twitter_id"
    t.text     "media_url"
    t.integer  "retweets"
    t.text     "content"
    t.float    "param"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "lang"
  end

  add_index "best_tweets", ["user_id"], :name => "index_best_tweets_on_user_id"

  create_table "best_tweets_tags", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "best_tweet_id"
  end

  add_index "best_tweets_tags", ["best_tweet_id", "tag_id"], :name => "index_best_tweets_tags_on_best_tweet_id_and_tag_id"
  add_index "best_tweets_tags", ["tag_id", "best_tweet_id"], :name => "index_best_tweets_tags_on_tag_id_and_best_tweet_id"

  create_table "block_of_shares", :force => true do |t|
    t.integer  "owner_id"
    t.integer  "holder_id"
    t.integer  "count"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "block_of_shares", ["holder_id"], :name => "index_block_of_shares_on_holder_id"
  add_index "block_of_shares", ["owner_id"], :name => "index_block_of_shares_on_owner_id"

  create_table "blog_posts", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.string   "title"
    t.boolean  "published",  :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "tag"
    t.string   "source"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "post_comments", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "blog_post_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "post_comments", ["blog_post_id"], :name => "index_post_comments_on_blog_post_id"
  add_index "post_comments", ["user_id"], :name => "index_post_comments_on_user_id"

  create_table "price_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "price_logs", ["user_id"], :name => "index_price_logs_on_user_id"

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
    t.string   "product_name"
    t.string   "country"
    t.string   "postal_code"
    t.string   "city"
    t.string   "full_name"
    t.string   "address"
    t.string   "email"
    t.string   "phone"
    t.integer  "cost"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
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
    t.boolean  "published"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
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
    t.integer  "twitter_id"
    t.string   "name"
    t.string   "nickname"
    t.string   "avatar"
    t.integer  "money",               :limit => 8
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "base_price"
    t.boolean  "is_admin",                         :default => false
    t.string   "token"
    t.string   "secret"
    t.boolean  "activated",                        :default => false
    t.string   "locale",                           :default => "en"
    t.boolean  "twitter_translation",              :default => true
    t.integer  "share_price"
    t.integer  "popularity"
    t.string   "email"
  end

  add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  add_index "users", ["twitter_id"], :name => "index_users_on_uid", :unique => true

end
