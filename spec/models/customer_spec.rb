require "rails_helper"

RSpec.describe Customer, type: :model do
  describe "relationships" do
    it { should have_many(:invoices) }
  end

  describe "validations" do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe ".top_customers" do
    it "returns the top 5 customers based on number of successful transactions" do
      customer_1 = create(:customer)
      customer_2 = create(:customer)
      customer_3 = create(:customer)
      customer_4 = create(:customer)
      customer_5 = create(:customer)
      customer_6 = create(:customer)

      invoice_1 = create(:invoice, customer: customer_1, status: 1)
      invoice_2 = create(:invoice, customer: customer_2, status: 1)
      invoice_3 = create(:invoice, customer: customer_3, status: 1)
      invoice_4 = create(:invoice, customer: customer_4, status: 1)
      invoice_5 = create(:invoice, customer: customer_5, status: 1)
      invoice_6 = create(:invoice, customer: customer_6, status: 1)

      transaction_1 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_2 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_3 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_4 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_5 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_6 = create(:transaction, invoice: invoice_1, result: 0)
      transaction_7 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_8 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_9 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_10 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_11 = create(:transaction, invoice: invoice_2, result: 0)
      transaction_12 = create(:transaction, invoice: invoice_2, result: 1)
      transaction_13 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_14 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_15 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_16 = create(:transaction, invoice: invoice_3, result: 0)
      transaction_17 = create(:transaction, invoice: invoice_3, result: 1)
      transaction_18 = create(:transaction, invoice: invoice_3, result: 1)
      transaction_19 = create(:transaction, invoice: invoice_4, result: 0)
      transaction_20 = create(:transaction, invoice: invoice_4, result: 0)
      transaction_21 = create(:transaction, invoice: invoice_4, result: 0)
      transaction_22 = create(:transaction, invoice: invoice_4, result: 1)
      transaction_23 = create(:transaction, invoice: invoice_4, result: 1)
      transaction_24 = create(:transaction, invoice: invoice_4, result: 1)
      transaction_25 = create(:transaction, invoice: invoice_5, result: 0)
      transaction_26 = create(:transaction, invoice: invoice_5, result: 0)
      transaction_27 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_28 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_29 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_30 = create(:transaction, invoice: invoice_5, result: 1)
      transaction_31 = create(:transaction, invoice: invoice_6, result: 0)
      transaction_32 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_33 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_34 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_35 = create(:transaction, invoice: invoice_6, result: 1)
      transaction_36 = create(:transaction, invoice: invoice_6, result: 1)

      query = Customer.top_customers

      expect(query).to eq([customer_1, customer_2, customer_3, customer_4, customer_5])
    end
  end
end