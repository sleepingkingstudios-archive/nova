# config/routes.rb

Rails.application.routes.draw do
  devise_for :users, :path => 'admin/users',
    :controllers => {
      :registrations => 'admin/registrations',
      :sessions      => 'admin/sessions'
    },
    :path_names => {
      :sign_in  => 'sign-in',
      :sign_out => 'sign-out',
      :sign_up  => 'register'
    }

  get 'index',           :to => 'directories#index'
  get 'directories/new', :to => 'directories#new'
  post 'directories',    :to => 'directories#create'

  get '*directories/index',           :to => 'directories#index'
  get '*directories/directories/new', :to => 'directories#new'
  post '*directories/directories',    :to => 'directories#create'
  get '*directories/edit',            :to => 'directories#edit'

  get '*directories', :to => 'directories#show', :constraints => lambda { |request| !(request.path =~ /\A\/?admin/) }

  root 'directories#show'
end # draw

# Include custom routing helpers.
Rails.application.routes.url_helpers.send :include, RoutesHelper
