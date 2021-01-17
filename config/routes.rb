Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :events do

      end
      resources :orders do

      end
    end
  end
end
