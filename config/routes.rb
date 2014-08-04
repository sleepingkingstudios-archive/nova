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

  get '*directories', :to => 'directories#show', :constraints => lambda { |request| !(request.path =~ /\A\/?admin/) }

  root 'directories#show'
end # draw
