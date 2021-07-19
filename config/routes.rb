Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      namespace :merchants do
        get '/find_all', to: 'search#index'
      end

      namespace :items do
        get '/find', to: 'search#show'
      end

      resources :merchants, only: [:index, :show] do
        scope module: 'merchant_items' do
          resources :items, only: :index
        end
      end

      resources :items do
        scope module: 'items_merchant' do
          resources :merchant, only: :index
        end
      end

      resources :items

    end
  end
end
