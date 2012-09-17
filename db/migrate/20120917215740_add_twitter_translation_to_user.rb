class AddTwitterTranslationToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter_translation, :boolean,:default=>true
  end
end
