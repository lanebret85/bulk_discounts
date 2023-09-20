class InvoiceItemsController < ApplicationController
    def update
      @invoice_item = InvoiceItem.find(params[:id])
      @merchant = Merchant.find(params[:merchant_id])
      @invoice = @invoice_item.invoice
      @invoice_item.update!(invoice_items_params)
      redirect_to merchant_invoice_path(@merchant, @invoice)
    end
  
    private
     def invoice_items_params
        params.permit(:status)
     end
end