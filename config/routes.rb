# config/routes.rb

Rails.application.routes.draw do
  devise_for :users

  get '*directories', :to => 'directories#show'

  root 'directories#show'
end # draw
