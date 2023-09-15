require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many(:invoices) }
  end

  describe "full_name" do
    it "returns the customers full name" do
      customer1 = Customer.create!(first_name: "Eddie", last_name: "Izzard")
      customer2 = Customer.create!(first_name: "Joe", last_name: "Franco")

      expect(customer1.full_name).to eq("Eddie Izzard")
      expect(customer2.full_name).to eq("Joe Franco")
    end
  end
end