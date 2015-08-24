Rails.application.routes.draw do

  root :to                => redirect('/mdwiki')

  get 'mdwiki'            => 'pages#index'
  get 'mdwiki/new(/:id)'  => 'pages#new'
  get 'mdwiki/edit'       => 'pages#edit_home'
  get 'mdwiki/tree(/:id)' => 'pages#tree'
  get 'mdwiki/:id'        => 'pages#show'
  get 'mdwiki/:id/edit'   => 'pages#edit'
  
  post 'mdwiki/new(/:id)' => 'pages#create'
  post 'mdwiki/edit'      => 'pages#update_home'
  post 'mdwiki/:id/edit'  => 'pages#update'
  
  delete 'mdwiki/:id'     => 'pages#delete'
end
