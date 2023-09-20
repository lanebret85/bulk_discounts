class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
    @top_five_merchants = Merchant.top_merchants
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def new
  end

  def create
    merchant = Merchant.new(merchant_params)
    if merchant.save
      redirect_to admin_merchants_path
      flash[:notice] = "Merchant was created successfully!"
    else
      redirect_to new_admin_merchant_path
      flash[:alert] = "Merchant was not created successfully, please fill in a name!"
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.update(
      merchant_params
    )

    if merchant.update(merchant_params)
      if params[:status].nil?
        redirect_to admin_merchant_path(merchant)
        flash[:notice] = "Merchant information has been successfully updated!"
      else
        redirect_to admin_merchants_path
      end
    else
      redirect_to edit_admin_merchant_path(merchant)
      flash[:alert] = "Information was not successfully updated, please fill in a name!"
    end
  end

  private

  def merchant_params
    params.permit(:name, :status)
  end
end