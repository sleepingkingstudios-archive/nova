# config/routes.rb

Rails.application.routes.draw do
  def features *names
    options = names.last.is_a?(Hash) ? names.pop : {}

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

      # Generate #preview routes.
      if options[:preview]
        post "#{scope_name}/preview",              :to => "features/#{scope_name}#preview"
        post "*directories/#{scope_name}/preview", :to => "features/#{scope_name}#preview"
      end # if
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

    resources :settings, :only => %i(index update)
  end # namespace

  scope :module => :admin do
    # Import/Export Routes

    get 'directories/import',              :to => 'directories#import_directory'
    get '*directories/directories/import', :to => 'directories#import_directory'

    get 'features/import',                 :to => 'directories#import_feature'
    get '*directories/features/import',    :to => 'directories#import_feature'

    get 'export',                          :to => 'resources#export'
    get '*directories/export',             :to => 'resources#export'

    # Publishing Routes

    put '*directories/publish',   :to => 'resources#publish'
    put '*directories/unpublish', :to => 'resources#unpublish'

    # RESTful Routes

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

    features :blogs
    features :pages, :preview => true

    get ':blog/posts',              :to => "features/blog_posts#index"
    get "*directories/:blog/posts", :to => "features/blog_posts#index"

    get ':blog/posts/new',              :to => "features/blog_posts#new"
    get "*directories/:blog/posts/new", :to => "features/blog_posts#new"

    post ':blog/posts/preview',              :to => "features/blog_posts#preview"
    post "*directories/:blog/posts/preview", :to => "features/blog_posts#preview"

    post ':blog/posts',              :to => "features/blog_posts#create"
    post "*directories/:blog/posts", :to => "features/blog_posts#create"
  end # namespace

  get '*directories', :to => 'resources#show', :constraints => lambda { |request| Page.reserved_slugs.none? { |slug| request.path =~ /(\A|\/)#{slug}(\/|\z)/ } }

  root 'resources#show'
end # draw
