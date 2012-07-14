class ProductInvoicesController < ApplicationController
	def create
		p = params[:create]
		user = User.find_by_nickname(p[:user])
		product = Product.find(p[:product_id].to_i)
		 
		User.transaction do
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

		redirect_to '/products/showcase'
	end

	def index
		@product_invoices = ProductInvoice.find(:all)
	end
end
