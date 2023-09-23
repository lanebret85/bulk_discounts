Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get "/merchants/:merchant_id/dashboard", to: "merchants#show"

  get "/merchants/:merchant_id/bulk_discounts/:bulk_discount_id/create", to: "merchant_bulk_discounts#create"

  resources :merchants do
    resources :invoices, only: [:index, :show, :update]
    resources :invoice_items, only: [:update]
    resources :items
    resources :bulk_discounts, only: [:index, :show, :new, :create]
  end
  
  namespace :admin do
    resources :invoices, only: [:index, :show, :update]
    resources :merchants
  end

  resources :admin, only: [:index]
end
