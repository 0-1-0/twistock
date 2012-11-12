class ProductInvoice < ActiveRecord::Base
  attr_accessible :address, :city, :country, :email, :full_name, :phone, :postal_code, :status, :user_id

  # TODO: вытащить простановку цены на after_create

  belongs_to :user
  belongs_to :product
end
