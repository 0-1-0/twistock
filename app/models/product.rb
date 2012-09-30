class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price, :short_description, :priority
  has_many :product_invoices

  scope :prioritized, where{priority > 0}.order(:priority)

  def self.create_invoice(user, p) # p means params
    User.transaction do
      product = Product.find(p[:product_id].to_i)

      raise ActiveRecord::Rollback if user.money < product.price

      user.money -= product.price
      user.save

      ProductInvoice.create(
        product: product.name,
        user_id: user.id,
        product_id: product.id,
        country: p[:country],
        total_cost: product.price,
        postal_code: p[:postal_code],
        city: p[:city],
        full_name: p[:full_name],
        address: p[:address],
        email: p[:email],
        phone: p[:phone],
        status: 'pending'
      )
    end
  end
end
