require 'rails_helper'

RSpec.describe "Merchants dashboard", type: :feature do
    describe "as a merchant" do
        it "Shows name of the merchant on dashboard" do
            merchant1 = Merchant.create!(name: "BOB BURGER SHOP")

            visit "/merchants/#{merchant1.id}/dashboard"

            expect(page).to have_content(merchant1.name)
        end
    end

    describe "Shows merchant links" do 
        it "has a items index link" do
            merchant1 = Merchant.create!(name: "BOB BURGER SHOP")

            visit "/merchants/#{merchant1.id}/dashboard"

            expect(page).to have_link('My Items')
            click_link("My Items")
            expect(current_path).to eq("/merchants/#{merchant1.id}/items")
        end
    end
end