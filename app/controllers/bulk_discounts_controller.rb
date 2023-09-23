class BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.create!(quantity_threshold: params[:quantity_threshold], percentage_discount: params[:percentage_discount], description: "#{((params[:percentage_discount]).to_f*100).to_i}% off #{params[:quantity_threshold]} items or more")
    redirect_to "/merchants/#{merchant.id}/bulk_discounts/#{bulk_discount.id}/create"
    # MerchantBulkDiscount.create!(merchant: merchant, bulk_discount: bulk_discount)
    # redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end
end