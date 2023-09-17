class ItemsController < ApplicationController
   def index
      @merchant = Merchant.find(params[:merchant_id])
   end

   def show
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:item_id])
   end

   def edit
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:item_id])
   end

   def update
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:item_id])

      if params[:commit] == 'Enable'
         @item.update(status: 'enabled')
      elsif params[:commit] == 'Disable'
         @item.update(status: 'disabled')
      end

      if @item.update(item_params)
         redirect_to "/merchants/#{@merchant.id}/items/#{@item.id}"
         flash[:success] = "Item information updated successfully."
      else
         redirect_to "/merchants/#{@merchant.id}/items/#{@item.id}/edit"
         flash[:alert] = "Not all updates were saved, please try again."
      end
   end

   private 

   def item_params
      params.require(:item).permit(:name, :description, :unit_price, :status)
    end
end