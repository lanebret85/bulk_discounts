class ItemsController < ApplicationController
   def index
      @merchant = Merchant.find(params[:merchant_id])
   end

   def show
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:id])
   end

   def new
      @merchant = Merchant.find(params[:merchant_id])
   end

   def create
      @merchant = Merchant.find(params[:merchant_id])
      Item.create!(name: params[:name], description: params[:description], unit_price: params[:unit_price], merchant_id: params[:merchant_id])
      redirect_to "/merchants/#{@merchant.id}/items"
   end

   def edit
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:id])
   end

   def update
      @merchant = Merchant.find(params[:merchant_id])
      @item = Item.find(params[:id])

      if params[:commit] == 'Enable'
         @item.update(status: 'enabled')
         redirect_to merchant_items_path(@merchant.id)
      elsif params[:commit] == 'Disable'
         @item.update(status: 'disabled')
         redirect_to merchant_items_path(@merchant.id)

      elsif @item.update(item_params)
         redirect_to merchant_item_path(@merchant, @item)
         flash[:success] = "Item information updated successfully."
      else
         redirect_to edit_merchant_item_path(@merchant, @item)
         flash[:alert] = "Not all updates were saved, please try again."
      end
   end

   private 

   def item_params
      params.require(:item).permit(:name, :description, :unit_price, :status)
   end
end