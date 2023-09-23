# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
@merchant1 = Merchant.create!(name: "BOB BURGER SHOP")
@merchant2 = Merchant.create!(name: "POP BURGER SHOP")

@bulk_discount1 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.2, description: "20% off 10 items or more")
@bulk_discount2 = BulkDiscount.create!(quantity_threshold: 15, percentage_discount: 0.3, description: "30% off 15 items or more")
@bulk_discount3 = BulkDiscount.create!(quantity_threshold: 10, percentage_discount: 0.25, description: "25% off 10 items or more")

@merchant_bulk_discount1 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount1)
@merchant_bulk_discount2 = MerchantBulkDiscount.create!(merchant: @merchant1, bulk_discount: @bulk_discount2)
@merchant_bulk_discount3 = MerchantBulkDiscount.create!(merchant: @merchant2, bulk_discount: @bulk_discount3)