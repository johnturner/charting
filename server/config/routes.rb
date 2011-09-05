ActionController::Routing::Routes.draw do |map|
  map.resources :goals, :member => {:adopt => :get} do |goals|
    goals.resources :notes
    goals.resources :users
    goals.resources :sources
  end
  
  map.resources :notes, :member => {:full_text => :get, :set_goals => :put}
  map.resources :users, :collection => {:logout => :get, :login => :post}
  map.resources :sources
  map.me 'me', :controller => :users, :action => :me
  map.api_key 'api_key.:format', :controller => :users, :action => :api_key
  map.verify_api_key 'verify_api_key.:format', :controller => :users, :action => :verify_api_key
  map.export 'export', :controller => :goals, :action => :export
  map.connect 'goals/:id/export', :controller => :goals, :action => 'download_csv'
  map.download_csv 'goals/download_csv', :controller => :goals, :action => 'download_csv'
  map.search 'search', :controller => :search, :action => :search
  map.inbox 'inbox', :controller => :notes, :action => :inbox
  map.inbox_sources 'inbox_sources', :controller => :sources, :action => :inbox
  map.all_goals 'all_goals', :controller => :goals, :action => :all_goals
  map.all_sources 'all_sources', :controller => :sources, :action => :all_sources
  map.all_notes 'all_notes', :controller => :notes, :action => :all_notes
  map.create_note 'create_note.:format', :controller => :notes, :action => :create
  map.js_lib 'js_lib.js', :controller => :js_lib, :action => :js_lib

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
   map.root :controller => "welcome", :action => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
