ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

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

  map.namespace :creation do |creation|
    creation.connect 'images/tag', :controller => 'images', :action => 'tag'

    creation.resources :item_bases, :recipes, :images,
      :activities,
      :areas, :area_bases, :area_links,
      :event_bases,
      :opportunities, :opportunity_bases,
      :intrinsic_bases,
      :shops,
      :except => :destroy

    creation.connect 'image_upload/:action', :controller => "image_upload"

    creation.root :controller => "creation"
  end

  map.resources :areas, :recipes, :only => [:index, :show]
  map.resources :shops, :only => [:index, :show, :edit]
  map.resources :characters, :except => :destroy


  map.connect 'actions/:action', :controller => "actions"
  map.connect 'meta/:action', :controller => "meta"
  map.connect 'compile', :controller => "compile", :action => 'create', :conditions => {:method => :post}

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "game"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action'
end
