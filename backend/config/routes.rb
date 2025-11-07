Rails.application.routes.draw do
  devise_for :users
  get "health/show"
  root to: "health#show"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "/up", to: "health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      devise_for :users,
        path: '',
        path_names: {
          sign_in: 'login',
          sign_out: 'logout',
          registration: 'signup'
        },
        controllers: {
          sessions: 'api/v1/users/sessions',
          registrations: 'api/v1/users/registrations'
        }

      # 認証済ユーザー情報取得
      get '/me', to: 'users#me'

      # 投稿とHooray!
      resources :posts, only: [:index, :create, :show, :destroy] do
        resource :hooray, only: [:create, :destroy]
      end
    end
  end
end
