Rails.application.routes.draw do
  get "health/show"
  root to: "health#show"

  get "/up", to: "health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # 🚨 Deviseの設定を全てこのブロック内で完結させます 🚨
      devise_for :users,
        # sessions, registrationsは必要なのでskipしない
        # passwords, confirmationsなど不要なものだけをskipします
        skip: [:passwords, :confirmations],

        # カスタムコントローラーを指定
        controllers: {
          sessions: 'api/v1/sessions',
          registrations: 'api/v1/registrations'
        },

        # URLセグメントの調整: /api/v1/users/login ではなく /api/v1/login にするために path: ''
        path: '',

        # パス名の変更: /sign_in や /registration ではなく /login や /signup を使う
        path_names: {
          sign_in: 'login',
          sign_out: 'logout',
          registration: 'signup'
        }

      # 🚨 注意: devise_forがこれらのルートを生成するため、以下の行は削除します
      # post 'login', to: 'sessions#create'
      # delete 'logout', to: 'sessions#destroy'
      # post 'signup', to: 'registrations#create'

      # 認証済ユーザー情報取得
      get 'me', to: 'users#me'

      # 投稿とHooray!
      resources :posts, only: [:index, :create, :show, :destroy] do
        resource :hooray, only: [:create, :destroy]
      end
    end
  end
end