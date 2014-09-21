# app/controllers/application_controller.rb

require 'errors/authentication_error'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def authenticate_user!
    raise Nova::AuthenticationError.new(request) unless user_signed_in?
  end # method authenticate_user
end # class
