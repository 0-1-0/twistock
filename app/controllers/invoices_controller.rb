class InvoicesController < ApplicationController
  before_filter :admin_required

  def index
    @invoices = ProductInvoice.find :all
  end

  def update
    @invoice = ProductInvoice.find params[:id]
    @invoice.update_attributes params[:invoice]
  end

  def destroy
    @invoice = ProductInvoice.find params[:id]
    @invoice.destroy

    redirect_to :back
  end

  def edit
    @invoice = ProductInvoice.find params[:id]
  end
end
