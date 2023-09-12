namespace :csv_load do
  desc "load customer data from csv"
  task customers: :environment do
  
  end

  desc "load invoice item data from csv"
  task invoice_items: :environment do

  end

  desc "load invoice data from csv"
  task invoices: :environment do

  end

  desc "load item data from csv"
  task items: :environment do

  end

  desc "load merchant data from csv"
  task merchants: :environment do

  end

  desc "load transaction data from csv"
  task transactions: :environment do

  end

  desc "load all data from csvs"
  task all: :environment do

  end
end
