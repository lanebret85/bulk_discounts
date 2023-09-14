class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    merchant.update(
      merchant_params
    )

    redirect_to "/admin/merchants/#{merchant.id}"
    flash[:notice] = "Merchant information has been successfully updated!"
  end

  private

  def merchant_params
    params.permit(:name)
  end
end