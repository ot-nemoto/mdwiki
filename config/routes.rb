Rails.application.routes.draw do

  root :to                => redirect('/mdwiki')

  get 'mdwiki'            => 'pages#index'
  get 'mdwiki/new(/:id)'  => 'pages#new'
  get 'mdwiki/edit'       => 'pages#edit_home'
  get 'mdwiki/tree(/:id)' => 'pages#pagelist_tree'
  get 'mdwiki/:id'        => 'pages#show'
  get 'mdwiki/:id/move'   => 'pages#move_tree'
  get 'mdwiki/:id/edit'   => 'pages#edit'

  post 'mdwiki/new(/:id)' => 'pages#create'
  post 'mdwiki/edit'      => 'pages#update_home'
  post 'mdwiki/:id/edit'  => 'pages#update'
  post 'mdwiki/:id/move/:parent_id' \
                          => 'pages#move'

  delete 'mdwiki/:id'     => 'pages#delete'
end
