ActionController::Routing::Routes.draw do |map|
     map.resources :file_assets
     
     # This creates routes named asset_file_assets, new_asset_file_asset, etc.
     # The routes map to the :file_assets controller with the param :container_id 
     # which is then used within the controller to deal with parent - child relationships 
     # between Assets and the FileAssets inside them.
     map.resources :file_assets, :path_prefix => '/assets/:container_id', :name_prefix => "asset_"
     
     map.resources :assets do |assets|
       assets.resources :downloads, :only=>[:index]
     end
end