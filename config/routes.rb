Twitterexchange::Application.routes.draw do
  get "tjournal/top_tweets"

  get "settings/twitter_translation"

  resources :main_page_streams

  get "robot/dashboard"

  get "robot/history"
  post 'robot/add'

  get "history/transactions"

  get "history_controller/operations"


  match '/products/showcase', :controller => 'products', :action => 'showcase'
  resources :products

  get "stream/infoline"

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
    resources :profiles
    collection do
      post 'buy'
      post 'sell'
      post 'sell_retention'
      post 'buy_followers'
    end
  end

  resources :product_invoices
  match '/product_invoices/create', :to => 'product_invoices#create'

  match '/history', :to => 'history#transactions'
  match '/iportfolio', :to => 'history#investment_portfolio'
  match '/holders', :to => 'history#share_holders'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
