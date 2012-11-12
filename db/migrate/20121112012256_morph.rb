class Morph < ActiveRecord::Migration
  def change
    drop_table :main_page_streams

    rename_column :product_invoices, :total_cost, :cost
  end
end
