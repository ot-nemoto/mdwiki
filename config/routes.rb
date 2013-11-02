Mdwiki::Application.routes.draw do

  get 'mdwiki/login'     => 'login#index'
  post 'mdwiki/login'    => 'login#login'
  post 'mdwiki/logout'   => 'login#logout'

  get 'mdwiki'           => 'pages#main'
  get 'mdwiki/:id'       => 'pages#show'
  get 'mdwiki/:id/new'   => 'pages#new'
  get 'mdwiki/:id/edit'  => 'pages#edit'

  post 'mdwiki/preview'  => 'pages#preview'
  post 'mdwiki/:id/insert'   => 'pages#insert'
  post 'mdwiki/:id/update'   => 'pages#update'
  post 'mdwiki/:id/upload'   => 'pages#upload'
  post 'mdwiki/:id/list' => 'pages#list'

#  post 'mdwiki/:id/new'  => 'pages#new'
#  post 'mdwiki/:id/edit' => 'pages#edit'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
