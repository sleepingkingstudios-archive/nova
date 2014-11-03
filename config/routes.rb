# config/routes.rb

Rails.application.routes.draw do
  def features *names
    names.each do |name|
      scope_name = name.to_s.underscore.pluralize

      # Generate #index routes.
      get "#{scope_name}",              :to => "features/#{scope_name}#index"
      get "*directories/#{scope_name}", :to => "features/#{scope_name}#index"

      # Generate #new routes.
      get "#{scope_name}/new",              :to => "features/#{scope_name}#new"
      get "*directories/#{scope_name}/new", :to => "features/#{scope_name}#new"

      # Generate #create routes.
      post "#{scope_name}",              :to => "features/#{scope_name}#create"
      post "*directories/#{scope_name}", :to => "features/#{scope_name}#create"
    end # each
  end # method features

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

  namespace :admin do
    get 'contents/:content_type/fields', :to => 'features/contents#fields'
  end # namespace

  scope :module => :admin do
    get 'dashboard',                    :to => 'directories#dashboard'
    get '*directories/dashboard',       :to => 'directories#dashboard'

    get 'directories',                  :to => 'directories#index'
    get '*directories/directories',     :to => 'directories#index'

    get 'directories/new',              :to => 'directories#new'
    get '*directories/directories/new', :to => 'directories#new'

    post 'directories',                 :to => 'directories#create'
    post '*directories/directories',    :to => 'directories#create'

    get '*directories/edit',            :to => 'resources#edit'

    patch '*directories',               :to => 'resources#update'
    put '*directories',                 :to => 'resources#update'

    delete '*directories',              :to => 'resources#destroy'

    features :blogs, :pages
  end # namespace

  get '*directories', :to => 'resources#show', :constraints => lambda { |request| Page.reserved_slugs.none? { |slug| request.path =~ /\A\/?#{slug}/ } }

  root 'resources#show'
end # draw

# Include custom routing helpers.
Rails.application.routes.url_helpers.send :include, RoutesHelper
