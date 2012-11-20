class StoreController < ApplicationController
  def index
  end

  def show
    @product = Product.find params[:id]
    @product_invoice = ProductInvoice.new
  end
end
