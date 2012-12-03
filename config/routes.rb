Twitterexchange::Application.routes.draw do
  namespace :api do
    resources :transactions, only: [:index] do
      collection do
        get 'history'
      end
    end

    resources :users, only: [:index, :show, :update] do
      member do
        post 'buy'
        post 'sell'
      end
    end
  end

  resources :blog_posts, :path=>'blog' do
    member do
      post 'add_comment'
    end
  end

  resources :invoices
  
  resources :products do
    member do
      post 'create_invoice'
    end
  end

  resources :store, only: [:index, :show]

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :user, only: [:show, :update] do
    member do
      post  'set_mail'
      get   'get_info'
      post  'buy'
      post  'sell'
    end

    collection do
      post  'search'
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

  root to: 'main#index'

  match '/auth/:provider/callback', :to => 'session#create'
  match '/auth/failure',            :to => 'session#failure'
  get   'sign_out'                      => 'session#destroy'
end
