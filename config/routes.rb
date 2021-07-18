Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do

      resources :merchants, only: [:index, :show] do
        scope module: 'merchant_items' do
          resources :items, only: :index
        end
      end
      
    end
  end
end
