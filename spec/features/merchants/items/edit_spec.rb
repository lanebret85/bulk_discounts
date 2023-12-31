require 'rails_helper'

RSpec.describe "Item Edit Page" do
  describe "Edit an item's details" do
    before (:each) do
      @merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
      @item1 = Item.create!(name: "Burger", unit_price: 15, merchant_id: @merchant1.id, description: "Food")
      visit edit_merchant_item_path(@merchant1, @item1)
    end

    it "has a form with the current information pre-filled" do
      expect(page).to have_content("Name:")
      expect(page).to have_content("Description:")
      expect(page).to have_content("Current Selling Price:")
      expect(page).to have_button("Submit")

      fill_in "item[name]", with: "Corn Dog"
      fill_in "item[description]", with: ""
      fill_in "item[unit_price]", with: 10
      click_button "Submit"
      expect(current_path).to eq("/merchants/#{@merchant1.id}/items/#{@item1.id}/edit")
      expect(page).to have_content("Not all updates were saved, please try again.")

      fill_in "item[name]", with: "Hot Dog"
      fill_in "item[description]", with: "Newer Food"
      fill_in "item[unit_price]", with: 10
      click_button "Submit"
      expect(current_path).to eq(merchant_item_path(@merchant1, @item1))
      
      expect(page).to have_content("Item information updated successfully.")
      
      within("div.item-details") do
        expect(page).to have_content("Hot Dog")
        expect(page).to have_content("Newer Food")
        expect(page).to have_content("10")
      end
    end
  end
end