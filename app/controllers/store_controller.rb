class StoreController < ApplicationController
  def index
    @white_bg = true
    @product_invoice = ProductInvoice.new
  end

  def show
    @white_bg = true
    @product = Product.find params[:id]
    @product_invoice = ProductInvoice.new
  end
end
