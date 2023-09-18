class AdminController < ApplicationController
  def index
    @top_five_customers = Customer.top_customers
  end
end