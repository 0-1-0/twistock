class Product < ActiveRecord::Base
  attr_accessible :description, :name, :price, :short_description, :priority, :published
  has_many :product_invoices, dependent: :nullify

  scope :published,   where(published: true)
  scope :prioritized, published.order(:priority)

  def create_invoice(user, params) # p means params
    User.transaction do
      raise ActiveRecord::Rollback if user.money < price

      user.money -= price
      user.save

      product_invoice = ProductInvoice.new(
        product_name:   name,
        #user_id:        user.id,
        #product_id:     id,
        country:        params[:country],
        #cost:           price,
        postal_code:    params[:postal_code],
        city:           params[:city],
        full_name:      params[:full_name],
        address:        params[:address],
        email:          params[:email],
        phone:          params[:phone],
        status:         'pending'
      )

      product_invoice.user_id = user.id
      product_invoice.product_id = id      
      product_invoice.cost = price

      product_invoice.save
    end
  end
end
