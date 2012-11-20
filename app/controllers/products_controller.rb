class ProductsController < ApplicationController
  before_filter :admin_required

  def index
    @products = Product.find(:all)
  end

  def create
    @product = Product.new(params[:product])
    @product.save

    redirect_to products_path
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy

    redirect_to products_path
  end

  def update
    @product = Product.find(params[:id])

    @product.update_attributes params[:product]
    redirect_to :back
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create_invoice
    @product = Product.find(params[:id])
    @product.create_invoice(current_user, params[:product_invoice])

    redirect_to :back
  end
end
