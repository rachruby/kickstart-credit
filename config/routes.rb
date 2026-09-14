Rails.application.routes.draw do
  root "dashboard#show"

  resources :credit_accounts do
    resources :payments, only: [:create, :destroy] do
      member { patch :mark_paid }
    end
  end

  resources :disputes do
    member do
      patch :submit
      patch :resolve
    end
  end

  resources :score_entries, only: [:create, :destroy]
  resource :score_goal, only: [:new, :create, :edit, :update]

  namespace :api do
    namespace :v1 do
      resources :credit_accounts, only: [:index, :show]
    end
  end
end
