Mdwiki::Application.routes.draw do

  root :to                        => redirect("/mdwiki")

  get 'mdwiki/login'              => 'login#index'
  get 'mdwiki/search'             => 'search#search'
  get 'mdwiki'                    => 'pages#main'
  get 'mdwiki/:id'                => 'pages#show'
  get 'mdwiki/:id/new'            => 'pages#new'
  get 'mdwiki/:id/edit'           => 'pages#edit'

  post 'mdwiki/login'             => 'login#login'
  post 'mdwiki/logout'            => 'login#logout'
  post 'mdwiki/preview'           => 'pages#preview'
  post 'mdwiki/remove'            => 'pages#remove'
  post 'mdwiki/removeall'         => 'pages#remove_all'
  post 'mdwiki/insert'            => 'pages#insert'
  post 'mdwiki/update'            => 'pages#update'
  post 'mdwiki/list'              => 'pages#list'

  # attachment
  get  'mdwiki/attachment/:id/'   => 'attachment#show'
  post 'mdwiki/attachment/upload' => 'attachment#upload'
  post 'mdwiki/attachment/remove' => 'attachment#remove'
end
