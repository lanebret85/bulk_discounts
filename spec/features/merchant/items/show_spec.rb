require 'rails_helper'

RSpec.describe "Item Show Page" do
  describe "Item details" do
    before (:each) do
      @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
      @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id, description: "Food")
      visit merchant_item_path(@merchant1, @item1)
    end

    it "Should have the details of the item" do
      within("div.item-details") do
        expect(page).to have_content("Name: #{@item1.name}")
        expect(page).to have_content("Description: #{@item1.description}")
        expect(page).to have_content("Current Selling Price: #{@item1.unit_price}")
      end
    end

    it "Should have a link to update the details" do
      within("div.item-details") do
        expect(page).to have_link("Update Details")
      end
      click_link("Update Details")
      expect(current_path).to eq(edit_merchant_item_path(@merchant1, @item1))
    end
  end
end