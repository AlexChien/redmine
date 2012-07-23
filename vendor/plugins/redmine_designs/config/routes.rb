ActionController::Routing::Routes.draw do |map|
  map.resources :designs
  map.connect 'projects/:project_id/stats.:format', :controller => 'designs', :action => 'stats'
end