Mdwiki::Application.routes.draw do

  devise_for :users, :path => 'mdwiki/users', :controllers => {
    :sessions      => "users/sessions",
    :registrations => "users/registrations",
    :passwords     => "users/passwords"
  }

  root :to                        => redirect('/mdwiki')

  get 'mdwiki/search'             => 'search#search'

  get 'mdwiki'                    => 'pages#main'
  get 'mdwiki/:id'                => 'pages#show'
  get 'mdwiki/:id/new'            => 'pages#new'
  get 'mdwiki/:id/edit'           => 'pages#edit'

  post 'mdwiki/preview'           => 'pages#preview'
  post 'mdwiki/remove'            => 'pages#remove'
  post 'mdwiki/removeall'         => 'pages#remove_all'
  post 'mdwiki/list'              => 'pages#list'
  post 'mdwiki/save'              => 'pages#save'

  # attachment
  get  'mdwiki/attachment/:id/'   => 'attachment#show'
  post 'mdwiki/attachment/upload' => 'attachment#upload'
  post 'mdwiki/attachment/remove' => 'attachment#remove'
end
