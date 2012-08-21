class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price, :short_description, :priority
  has_many :product_invoices
end
