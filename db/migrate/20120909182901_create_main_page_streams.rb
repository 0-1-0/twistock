class CreateMainPageStreams < ActiveRecord::Migration
  def change
    create_table :main_page_streams do |t|
      t.string :eng_name
      t.string :ru_name
      t.text :list_of_users
      t.string :eng_tooltip
      t.string :tu_tooltip
      t.integer :priority,:default=>0

      t.timestamps
    end
  end
end
