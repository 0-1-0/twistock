class ProductInvoice < ActiveRecord::Base
  attr_accessible :address, :city, :country, :email, :full_name, :phone, :postal_code, :product
end
