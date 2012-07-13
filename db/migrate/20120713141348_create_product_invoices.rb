class CreateProductInvoices < ActiveRecord::Migration
  def change
    create_table :product_invoices do |t|
      t.Product :product
      t.string :country
      t.string :postal_code
      t.string :city
      t.string :full_name
      t.string :address
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
