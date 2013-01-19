class CreateActivityEvents < ActiveRecord::Migration
  def change
    create_table :activity_events do |t|
      t.references :user
      t.integer :price_change
      t.references :source, polymorphic: true

      t.timestamps
    end
    add_index :activity_events, :user_id
    add_index :activity_events, :source_id
  end
end
