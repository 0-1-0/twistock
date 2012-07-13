class ProductInvoice < ActiveRecord::Base
  attr_accessible :address, :city, :country, :email, :full_name, :phone, :postal_code, :product_id, :total_cost

  belongs_to :user
  belongs_to :product
end
