require "rails_helper"

RSpec.describe "Admin Merchant Update", type: :feature do
  describe "When I visit /admin/merchants/:merchant_id/edit I see a form to edit the merchant" do
    describe "When I update the info and click 'submit'" do
      it "Redirects me back to show page where the info is updated and I see a successfully updated flash message" do
        @merchant_1 = create(:merchant)

        visit "/admin/merchants/#{@merchant_1.id}/edit"

        expect(page).to have_content("Edit Merchant")
        expect(page).to have_content("Name:")

        fill_in "Name:", with: "A different name"

        click_button("Submit")

        expect(current_path).to eq("/admin/merchants/#{@merchant_1.id}")

        expect(page).to have_content("A different name")
      end
    end
  end
end