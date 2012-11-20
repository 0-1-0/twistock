class ProductInvoice < ActiveRecord::Base
  attr_accessible :product_name, :address, :city, :country, :email, :full_name, :phone, :postal_code, :status

  belongs_to :user
  belongs_to :product
end
