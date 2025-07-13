Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :conversions, only: [:index, :create]
      post 'convert', to: 'conversions#convert'
      get 'health', to: 'health#index'
      get 'debug', to: 'health#debug'
    end
  end
end
