require 'rails_helper'

RSpec.describe "Item Show Page" do
  describe "Item details" do
    it "Should have the details of the item" do
      @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
      @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id, description: "Food")
      visit "/merchants/#{@merchant1.id}/items/#{@item1.id}"

      within("div.item-details") do
        expect(page).to have_content("Name: #{@item1.name}")
        expect(page).to have_content("Description: #{@item1.description}")
        expect(page).to have_content("Current Selling Price: #{@item1.unit_price}")
      end
    end
  end
end