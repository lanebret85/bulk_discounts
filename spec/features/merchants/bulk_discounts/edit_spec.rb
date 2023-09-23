require 'rails_helper'

RSpec.describe "Merchant Bulk Discount Edit", type: :feature do
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
      it "displays a link to edit the bulk discount" do
        visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}"

        expect(page).to have_link("Edit this discount")
      end

      describe "When I click this link" do
        it "takes me to a new page with a form to edit the discount and I see that the discounts current attributes are pre-populated in the form" do
          visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}"

          click_link "Edit this discount"

          expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}/edit")

          expect(page).to have_content("Edit this Discount")

          expect(page).to have_content("Minimum items:")
          expect(page).to have_content("Discount as a decimal:")
          expect(page).to have_field(:quantity_threshold)
          expect(page).to have_field(:percentage_discount)
          # expect(page).to have_text("#{@bulk_discount1.quantity_threshold}")
          # expect(page).to have_text("#{@bulk_discount1.percentage_discount}")
        end

        describe "When I change any/all of the information and click submit" do
          it "redirects me to the bulk discounts show page and I see that the discounts attributes have been updated" do
            visit "/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}/edit"

            fill_in :quantity_threshold, with: 12
            fill_in :percentage_discount, with: 0.25

            click_on "Submit"

            expect(current_path).to eq("/merchants/#{@merchant1.id}/bulk_discounts/#{@bulk_discount1.id}")

            expect(page).to have_content("25% off 12 items or more")
            expect(page).to have_content("Minimum Items: 12")
            expect(page).to have_content("Discount as a Decimal: 0.25")
          end
        end
      end
    end
  end
end