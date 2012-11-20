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

      ProductInvoice.create(
        product:        name,
        user_id:        user.id,
        product_id:     id,
        country:        params[:country],
        total_cost:     price,
        postal_code:    params[:postal_code],
        city:           params[:city],
        full_name:      params[:full_name],
        address:        params[:address],
        email:          params[:email],
        phone:          params[:phone],
        status:         'pending'
      )
    end
  end
end
