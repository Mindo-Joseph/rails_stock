Rails.application.routes.draw do
  get 'notifications/index'
  get 'notifications/mark_as_read'
  devise_for :users

  resources :products do
    collection do
      get :export
    end
  end
  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
    end
  end

  root "products#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
