# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Customer.destroy_all
Invoice.destroy_all
Transaction.destroy_all
InvoiceItem.destroy_all
Item.destroy_all
Merchant.destroy_all
MerchantBulkDiscount.destroy_all
BulkDiscount.destroy_all

Rake::Task["csv_load:all"].invoke

@merchant_1 = Merchant.create!(name: "BOB BURGER SHOP")
@merchant_2 = Merchant.create!(name: "POP BURGER SHOP")

@item_1 = Item.create!(name: "Item 1", unit_price: 1, merchant_id: @merchant_1.id, description: "blah")
@item_2 = Item.create!(name: "Item 2", unit_price: 1, merchant_id: @merchant_1.id, description: "bloo")
@item_3 = Item.create!(name: "Item 3", unit_price: 1, merchant_id: @merchant_2.id, description: "bleh")
@item_4 = Item.create!(name: "Item 4", unit_price: 1, merchant_id: @merchant_2.id, description: "blugh")

@customer_1 = Customer.create!(first_name: "Lane", last_name: "Bretschneider")
@customer_2 = Customer.create!(first_name: "Taylor", last_name: "Bretschneider")
@customer_3 = Customer.create!(first_name: "Bill", last_name: "Bretschneider")
@customer_4 = Customer.create!(first_name: "Elizabeth", last_name: "Bretschneider")
@customer_5 = Customer.create!(first_name: "Carly", last_name: "Bretschneider")
@customer_6 = Customer.create!(first_name: "Luna", last_name: "Bretschneider")

@invoice_1 = Invoice.create!(customer: @customer_1, status: 1)
@invoice_2 = Invoice.create!(customer: @customer_2, status: 1)
@invoice_3 = Invoice.create!(customer: @customer_3, status: 1)
@invoice_4 = Invoice.create!(customer: @customer_4, status: 1)
@invoice_5 = Invoice.create!(customer: @customer_5, status: 1)
@invoice_6 = Invoice.create!(customer: @customer_6, status: 1)
@invoice_7 = Invoice.create!(customer: @customer_1, status: 1)

@invoice_item_1 = InvoiceItem.create!(quantity: 3, unit_price: 57295, item_id: @item_1.id, invoice_id: @invoice_1.id, status: 2)
@invoice_item_2 = InvoiceItem.create!(quantity: 8, unit_price: 65020, item_id: @item_1.id, invoice_id: @invoice_2.id, status: 2)
@invoice_item_3 = InvoiceItem.create!(quantity: 7, unit_price: 20375, item_id: @item_1.id, invoice_id: @invoice_3.id, status: 2)
@invoice_item_4 = InvoiceItem.create!(quantity: 2, unit_price: 32563, item_id: @item_2.id, invoice_id: @invoice_4.id, status: 2)
@invoice_item_5 = InvoiceItem.create!(quantity: 5, unit_price: 10385, item_id: @item_2.id, invoice_id: @invoice_5.id, status: 2)
@invoice_item_6 = InvoiceItem.create!(quantity: 1, unit_price: 73920, item_id: @item_3.id, invoice_id: @invoice_6.id, status: 2)
@invoice_item_7 = InvoiceItem.create!(quantity: 5, unit_price: 11894, item_id: @item_3.id, invoice_id: @invoice_7.id, status: 1)
@invoice_item_8 = InvoiceItem.create!(quantity: 4, unit_price: 79285, item_id: @item_4.id, invoice_id: @invoice_1.id, status: 0)
@invoice_item_9 = InvoiceItem.create!(quantity: 3, unit_price: 32563, item_id: @item_4.id, invoice_id: @invoice_2.id, status: 1)

@bulk_discount_1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
@bulk_discount_2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
@bulk_discount_3 = BulkDiscount.create!(quantity_threshold: 5, percentage_discount: 0.05, description: "5% off 5 items or more")

Merchant.all.each do |merchant|
  MerchantBulkDiscount.create!(merchant: merchant, bulk_discount: @bulk_discount_1)
  MerchantBulkDiscount.create!(merchant: merchant, bulk_discount: @bulk_discount_2)
  MerchantBulkDiscount.create!(merchant: merchant, bulk_discount: @bulk_discount_3)
end