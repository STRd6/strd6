ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.open_id_complete 'session', :controller => 'sessions', :action => 'create', :requirements => { :method => :get }
  map.resource :session

  map.my_account '/my_account', :controller => 'accounts', :action => 'show'
  map.my_account '/edit_account', :controller => 'accounts', :action => 'edit'
  map.resources :accounts
end