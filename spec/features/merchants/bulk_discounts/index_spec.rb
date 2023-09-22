require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts Index", type: :feature do
  before (:each) do
    @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
    @merchant2 = Merchant.create!(name: "POP BURGER SHOP")

    @bulk_discount1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
    @bulk_discount2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
    @bulk_discount3 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.25, description: "25% off 10 items or more")

    @merchant_bulk_discount1 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount1)
    @merchant_bulk_discount2 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount2)
    @merchant_bulk_discount3 = MerchantBulkDiscount.create!(merchant: @merchant2, bulk_discount: @bulk_discount3)
  end

  describe "When I visit my merchant dashboard" do
    it "displays a link to view all my discounts" do
      visit "/merchants/#{@merchant1.id}/dashboard"

      within("#bulk_discounts") do
        expect(page).to have_link("View All Discounts")
      end
    end
    
    describe "When I click this link" do
      it "takes me to my bulk discounts index page where I see all of my bulk discounts including their percentage discount and quantity thresholds and each bulk discount listed includes a link to its show page" do
        visit "/merchants/#{@merchant1.id}/dashboard"

        click_link "View All Discounts"

        expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")

        expect(page).to have_content("All Discounts for #{@merchant1.name}")

        expect(page).to have_link("#{@bulk_discount1.description}")
        expect(page).to have_link("#{@bulk_discount2.description}")
        expect(page).to_not have_link("#{@bulk_discount3.description}")

        click_link "#{@bulk_discount1.description}"

        expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}")
      end
    end
  end
end