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

    get 'directories',                  :to => 'directories#index'
    get '*directories/directories',     :to => 'directories#index'

    get 'directories/new',              :to => 'directories#new'
    get '*directories/directories/new', :to => 'directories#new'
  end # namespace

  post 'directories',    :to => 'directories#create'

  post '*directories/directories',    :to => 'directories#create'
  get '*directories/edit',            :to => 'directories#edit'
  patch '*directories',               :to => 'directories#update'
  delete '*directories',              :to => 'directories#destroy'

  get '*directories', :to => 'directories#show', :constraints => lambda { |request| !Directory.reserved_slugs.any? { |slug| request.path =~ /\A\/?#{slug}/ } }

  root 'directories#show'
end # draw

# Include custom routing helpers.
Rails.application.routes.url_helpers.send :include, RoutesHelper
