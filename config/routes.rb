ActionController::Routing::Routes.draw do |map|
  map.resources :wineries
  map.resources :shipments, :member => {:additional => :any}, :collection => {:archive => :get}
  map.resources :shippers
  map.resources :users
  
  map.home_shipments 'shipments/home/:id', :controller => 'shipments', :action => 'home'
  map.archive_shipments 'shipments/archive/', :controller => 'shipments', :action => 'archive'
  map.connect 'shipments/item_list', :controller => 'shipments', :action => 'item_list'
  map.connect 'shipments/test_complete', :controller => 'shipments', :action => 'test_complete'
  #map.connect 'shipments/additional/:id', :controller => 'shipments', :action => 'additional'
  map.connect 'users/find_access', :controller => 'users', :action => 'find_access'
  
  map.login '/login', :controller => 'admin', :action => 'index'
  map.logout '/logout', :controller => 'admin', :action => 'logout'
  map.connect '/user_login', :controller => 'admin', :action => 'login'
  
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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => 'shipments', :action => 'home'

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
