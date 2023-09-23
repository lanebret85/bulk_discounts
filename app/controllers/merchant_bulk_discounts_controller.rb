class MerchantBulkDiscountsController < ApplicationController
  def create
    merchant = Merchant.find(params[:merchant_id])
    bulk_discount = BulkDiscount.find(params[:bulk_discount_id])
    MerchantBulkDiscount.create!(merchant: merchant, bulk_discount: bulk_discount)
    redirect_to "/merchants/#{merchant.id}/bulk_discounts"
  end
end