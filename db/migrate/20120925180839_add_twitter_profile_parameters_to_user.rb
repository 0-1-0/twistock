class AddTwitterProfileParametersToUser < ActiveRecord::Migration
  def change
    add_column :users, :tweets_num, :integer, :default=>0
    add_column :users, :retweets_num, :integer, :default=>0
    add_column :users, :followers_num, :integer, :default=>0
    add_column :users, :pop, :integer, :default=>0
  end
end
