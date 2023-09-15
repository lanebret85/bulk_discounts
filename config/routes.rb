Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"


  get "/merchants/:merchant_id/dashboard", to: "merchants#show"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/invoices", to: "invoices#index"
  get "/merchants/:merchant_id/invoices/:invoice_id", to: "invoices#show"

  get "/admin/merchants", to: "admin/merchants#index"
  get "/admin/merchants/new", to: "admin/merchants#new"
  get "/admin/merchants/:merchant_id", to: "admin/merchants#show"
  get "/admin/merchants/:merchant_id/edit", to: "admin/merchants#edit"
  patch "/admin/merchants/:merchant_id", to: "admin/merchants#update"
  post "/admin/merchants", to: "admin/merchants#create"
end
