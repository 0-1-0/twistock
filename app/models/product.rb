class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price, :short_description
  has_many :product_invoices
end
