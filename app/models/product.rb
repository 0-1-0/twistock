class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price
  has_many :product_invoices
end
