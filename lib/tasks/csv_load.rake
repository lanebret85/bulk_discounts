require "csv"

namespace :csv_load do
  desc "load customer data from csv"
  task customers: :environment do
    customers = CSV.open "./db/data/customers.csv", headers: true, header_converters: :symbol
    customers.each do |customer|
      Customer.create!(
        id: customer[:id],
        first_name: customer[:first_name],
        last_name: customer[:last_name],
        created_at: customer[:created_at],
        updated_at: customer[:updated_at]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
  end

  desc "load invoice item data from csv"
  task invoice_items: :environment do
    invoice_items = CSV.open "./db/data/invoice_items.csv", headers: true, header_converters: :symbol
    invoice_items.each do |item|
      InvoiceItem.create!(
        id: item[:id],
        item_id: item[:item_id],
        invoice_id: item[:invoice_id],
        quantity: item[:quantity],
        unit_price: item[:unit_price],
        status: item[:status],
        created_at: item[:created_at],
        updated_at: item[:updated_at]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end

  desc "load invoice data from csv"
  task invoices: :environment do
    invoices = CSV.open "./db/data/invoices.csv", headers: true, header_converters: :symbol
    invoices.each do |invoice|
      Invoice.create!(
        id: invoice[:id],
        customer_id: invoice[:customer_id],
        status: invoice[:status],
        created_at: invoice[:created_at],
        updated_at: invoice[:updated_at]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
  end

  desc "load item data from csv"
  task items: :environment do
    items = CSV.open "./db/data/items.csv", headers: true, header_converters: :symbol
    items.each do |item|
      Item.create!(
        id: item[:id],
        name: item[:name],
        description: item[:description],
        unit_price: item[:unit_price],
        merchant_id: item[:merchant_id],
        created_at: item[:created_at],
        updated_at: item[:updated_at]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
  end

  desc "load merchant data from csv"
  task merchants: :environment do
    merchants = CSV.open "./db/data/merchants.csv", headers: true, header_converters: :symbol
    merchants.each do |merchant|
      Merchant.create!(
        id: merchant[:id],
        name: merchant[:name],
        created_at: merchant[:created_at],
        updated_at: merchant[:updated_at]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
  end

  desc "load transaction data from csv"
  task transactions: :environment do
    transactions = CSV.open "./db/data/transactions.csv", headers: true, header_converters: :symbol
    transactions.each do |transaction|
      Transaction.create!(
        id: transaction[:id],
        invoice_id: transaction[:invoice_id],
        credit_card_number: transaction[:credit_card_number],
        credit_card_expiration_date: transaction[:credit_card_expiration_date],
        result: transaction[:result],
        created_at: transaction[:created_at],
        updated_at: transaction[:updated_at]
      )
    end
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
  end

  desc "load all data from csvs"
  task all: :environment do
    customers = CSV.open "./db/data/customers.csv", headers: true, header_converters: :symbol
    customers.each do |customer|
      Customer.create!(
        id: customer[:id],
        first_name: customer[:first_name],
        last_name: customer[:last_name],
        created_at: customer[:created_at],
        updated_at: customer[:updated_at]
      )
    end
    merchants = CSV.open "./db/data/merchants.csv", headers: true, header_converters: :symbol
    merchants.each do |merchant|
      Merchant.create!(
        id: merchant[:id],
        name: merchant[:name],
        created_at: merchant[:created_at],
        updated_at: merchant[:updated_at]
      )
    end
    invoices = CSV.open "./db/data/invoices.csv", headers: true, header_converters: :symbol
    invoices.each do |invoice|
      Invoice.create!(
        id: invoice[:id],
        customer_id: invoice[:customer_id],
        status: invoice[:status],
        created_at: invoice[:created_at],
        updated_at: invoice[:updated_at]
      )
    end
    items = CSV.open "./db/data/items.csv", headers: true, header_converters: :symbol
    items.each do |item|
      Item.create!(
        id: item[:id],
        name: item[:name],
        description: item[:description],
        unit_price: item[:unit_price],
        merchant_id: item[:merchant_id],
        created_at: item[:created_at],
        updated_at: item[:updated_at]
      )
    end
    transactions = CSV.open "./db/data/transactions.csv", headers: true, header_converters: :symbol
    transactions.each do |transaction|
      Transaction.create!(
        id: transaction[:id],
        invoice_id: transaction[:invoice_id],
        credit_card_number: transaction[:credit_card_number],
        credit_card_expiration_date: transaction[:credit_card_expiration_date],
        result: transaction[:result],
        created_at: transaction[:created_at],
        updated_at: transaction[:updated_at]
      )
    end
    invoice_items = CSV.open "./db/data/invoice_items.csv", headers: true, header_converters: :symbol
    invoice_items.each do |item|
      InvoiceItem.create!(
        id: item[:id],
        item_id: item[:item_id],
        invoice_id: item[:invoice_id],
        quantity: item[:quantity],
        unit_price: item[:unit_price],
        status: item[:status],
        created_at: item[:created_at],
        updated_at: item[:updated_at]
      )
    end

    ActiveRecord::Base.connection.reset_pk_sequence!('customers')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoices')
    ActiveRecord::Base.connection.reset_pk_sequence!('merchants')
    ActiveRecord::Base.connection.reset_pk_sequence!('items')
    ActiveRecord::Base.connection.reset_pk_sequence!('transactions')
    ActiveRecord::Base.connection.reset_pk_sequence!('invoice_items')
  end
end
