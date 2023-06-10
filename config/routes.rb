Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resource :session, only: [:create, :destroy]
    resources :sleep_time_records, only: [:index, :create] do
      collection do
        get :friends
      end
    end
    resources :users, only: [:index, :show] do
      member do
        get :following
        get :follower
        post :follow
        delete :unfollow
      end
    end
  end
end
