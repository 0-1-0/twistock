class ProductInvoicesController < ApplicationController
	before_filter :user_required
	before_filter :admin_required, :only=>[:index]

	def create
		return redirect_to :back unless signed_in?

		Product.create_invoice(current_user, params[:create])

		redirect_to '/products/showcase'
	end

	def index
		@product_invoices = ProductInvoice.find(:all)
	end
end
