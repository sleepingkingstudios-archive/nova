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

  scope :module => :admin do
    get 'dashboard',                    :to => 'directories#dashboard'
    get '*directories/dashboard',       :to => 'directories#dashboard'
  end # namespace

  get 'directories/new', :to => 'directories#new'
  post 'directories',    :to => 'directories#create'

  get '*directories/directories/new', :to => 'directories#new'
  post '*directories/directories',    :to => 'directories#create'
  get '*directories/edit',            :to => 'directories#edit'
  patch '*directories',               :to => 'directories#update'
  delete '*directories',              :to => 'directories#destroy'

  get '*directories', :to => 'directories#show', :constraints => lambda { |request| !(request.path =~ /\A\/?admin/) }

  root 'directories#show'
end # draw

# Include custom routing helpers.
Rails.application.routes.url_helpers.send :include, RoutesHelper
