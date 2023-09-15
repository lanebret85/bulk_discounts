class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end

  def new
  end

  def create
    Merchant.create!(name: params[:name])
    redirect_to "/admin/merchants"
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    merchant.update(
      merchant_params
    )
    # binding.pry
    if params[:status].nil?
      redirect_to "/admin/merchants/#{merchant.id}"
      flash[:notice] = "Merchant information has been successfully updated!"
    else
      redirect_to admin_merchants_path
    end
  end

  private

  def merchant_params
    params.permit(:name, :status)
  end
end