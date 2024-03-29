class ProductInvoice < ActiveRecord::Base
  attr_accessible :cost, :product_name, :address, :city, :country, :email, :full_name, :phone, :postal_code, :status

  belongs_to :user
  belongs_to :product

  has_one :activity_event, as: :source
end
