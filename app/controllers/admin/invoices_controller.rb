class Admin::InvoicesController < ApplicationController
  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
    @invoice_items = InvoiceItem.find_items(@invoice)
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.update!(status: params[:status])

    redirect_to "/admin/invoices/#{invoice.id}"
  end
end