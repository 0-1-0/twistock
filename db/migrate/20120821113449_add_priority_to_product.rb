class AddPriorityToProduct < ActiveRecord::Migration
  def change
    add_column :products, :priority, :integer,:default=>0
  end
end
