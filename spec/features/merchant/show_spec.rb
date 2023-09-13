require 'rails_helper'

RSpec.describe "Merchants dashboard", type: :feature do
    it "Shows name of the merchant on dashboard" do
        merchant1 = Merchant.create!(name: "BOB BURGER SHOP")

        visit "/merchants/#{merchant1.id}/dashboard"

        expect(page).to have_content(merchant1.name)
    end
end