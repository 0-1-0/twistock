class RenameProductToProductNameInProductInvoices < ActiveRecord::Migration
  def change
    rename_column :product_invoices, :product, :product_name
  end
end
