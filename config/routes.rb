Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[index create]
      resources :transactions, only: %i[create] do
        get :account_statement, on: :collection
        get :balance_state, on: :collection
      end
    end
  end
end
