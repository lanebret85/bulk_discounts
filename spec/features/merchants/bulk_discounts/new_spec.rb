require 'rails_helper'

RSpec.describe "Merchant Bulk Discounts New", type: :feature do
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
    describe "When I visit my bulk discounts index" do
      it "displays a link to create a new discount" do
        visit "/merchants/#{@merchant1.id}/bulk_discounts"

        within "#new_discount" do
          expect(page).to have_link("Create a new discount")
        end
      end

      describe "When I click this link" do
        it "takes me to a new page where I see a form to add a new bulk discount" do
          visit "/merchants/#{@merchant1.id}/bulk_discounts"

          click_link "Create a new discount"

          expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/new")
        end

        describe "When I fill in the form with valid data" do
          it "redirects me back to the bulk discounts index and I see my new bulk discount listed" do
            visit "/merchants/#{@merchant1.id}/bulk_discounts/new"

            fill_in :quantity_threshold, with: @bulk_discount4.quantity_threshold
            fill_in :percentage_discount, with: @bulk_discount4.percentage_discount

            click_on "Submit"

            expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts")

            expect(page).to have_link("#{@bulk_discount4.description}")
            expect(page).to_not have_link("#{@bulk_discount3.description}")
          end
        end
      end
    end
  end
end