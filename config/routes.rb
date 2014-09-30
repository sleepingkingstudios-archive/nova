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

    post 'directories',                 :to => 'directories#create'
    post '*directories/directories',    :to => 'directories#create'

    get 'pages',                        :to => 'features/pages#index'
    get '*directories/pages',           :to => 'features/pages#index'

    get 'pages/new',                    :to => 'features/pages#new'
    get '*directories/pages/new',       :to => 'features/pages#new'

    get '*directories/edit',            :to => 'resources#edit'

    patch '*directories',               :to => 'resources#update'
    put '*directories',                 :to => 'resources#update'

    delete '*directories',              :to => 'resources#destroy'
  end # namespace

  get '*directories', :to => 'resources#show', :constraints => lambda { |request| Directory.reserved_slugs.none? { |slug| request.path =~ /\A\/?#{slug}/ } }

  root 'resources#show'
end # draw

# Include custom routing helpers.
Rails.application.routes.url_helpers.send :include, RoutesHelper
