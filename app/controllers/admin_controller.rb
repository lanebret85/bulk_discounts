class AdminController < ApplicationController
  def index
    @top_five_customers = Customer.top_customers
    @incomplete_invoices = Invoice.incomplete_invoices
  end
end