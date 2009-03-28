ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'

  map.my_account '/my_account', :controller => 'accounts', :action => 'show'

  map.resource :session

  map.open_id_complete 'session', :controller => "sessions", :action => "create", :requirements => { :method => :get }
end