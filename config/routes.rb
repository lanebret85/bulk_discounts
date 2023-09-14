Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  get "/merchants/:merchant_id/dashboard", to: "merchants#show"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/invoices", to: "invoices#index"

  get "/admin/merchants", to: "admin/merchants#index"
  get "/admin/merchants/:id", to: "admin/merchants#show"
end
