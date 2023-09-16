require "rails_helper"

RSpec.describe "Admin Dashboard", type: :feature do
  before :each do
    
  end

  describe "When I visit the admin dashboard" do
    it "displays a header 'Admin Dashboard'" do
      visit "/admin"

      expect(page).to have_content("Admin Dashboard")
    end
  end
end