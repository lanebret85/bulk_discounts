require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Show", type: :feature do
  before (:each) do
    @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
    @merchant2 = Merchant.create!(name: "POP BURGER SHOP")

    @bulk_discount1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
    @bulk_discount2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
    @bulk_discount3 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.25, description: "25% off 10 items or more")
    @bulk_discount4 = BulkDiscount.create!(quantity_threshold: 5, percentage_discount: 0.05, description: "5% off 5 items or more")

    @merchant_bulk_discount1 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount1)
    @merchant_bulk_discount2 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount2)
    @merchant_bulk_discount3 = MerchantBulkDiscount.create!(merchant: @merchant2, bulk_discount: @bulk_discount3)
  end

  describe "As a merchant" do
    describe "When I visit my bulk discount show page" do
      it "displays the bulk discounts quantity threshold and percentage discount" do
        visit "merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}"

        expect(page).to have_content("#{@bulk_discount1.description}")
        expect(page).to have_content("Minimum Items: #{@bulk_discount1.quantity_threshold}")
        expect(page).to have_content("Discount as a Decimal: #{@bulk_discount1.percentage_discount}")
      end
    end
  end
end