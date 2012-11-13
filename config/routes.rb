Twitterexchange::Application.routes.draw do
  resources :product
  resources :store, only: [:index, :show]

  resources :user, only: [:show] do
    collection do
      post 'set_mail'
      post 'set_preferences'
    end
  end

  resources :exchange, only: [] do
    collection do
      post 'buy'
      post 'sell'
    end
  end


  get "main/index"

  resources :top_tweets, only: [:index] do
    collection do
      get 'edit_tags'
      post 'set_tags'
    end
  end

  resources :tag, only: [:index, :destroy, :create, :update]


  get "settings/twitter_translation"

  resources :main_page_streams

  get "robot/dashboard"

  get "robot/history"
  post 'robot/add'

  get "history/transactions"

  get "history_controller/operations"


  match '/products/showcase', :controller => 'products', :action => 'showcase'
  resources :products

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'welcome#index'
  get 'not_found' => 'welcome#not_found'
  get 'thanks' => 'welcome#thanks'
  get 'mobile' => 'welcome#mobile'

  match '/auth/:provider/callback', :to => 'session#create'
  match '/auth/failure',            :to => 'session#failure'
  get 'sign_out'  => 'session#destroy'

  resources :profiles, only: [:show] do
    collection do
      post 'search'
      post 'show'
      get  'change_language'
      post 'price_after_transaction'
    end
  end

  resources :shares, only: [] do
    resources :profiles, only: [:show]
    collection do
      post 'buy'
      post 'sell'
      post 'sell_retention'
      post 'buy_followers'
    end
  end

  resources :product_invoices, only: [:create, :index]
  match '/product_invoices/create', :to => 'product_invoices#create'

  match '/history', :to => 'history#transactions'
  match '/iportfolio', :to => 'history#investment_portfolio'
  match '/holders', :to => 'history#share_holders'
end
