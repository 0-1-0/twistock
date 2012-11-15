class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :tag
      t.string :source
      t.text :content

      t.timestamps
    end
  end
end
