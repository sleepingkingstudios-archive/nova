# app/controllers/application_controller.rb

require 'errors/authentication_error'

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def authenticate_user!
    # Null operation by default to allow any action or filter to run
    # authentication defensively. Can and should be overriden in
    # subclasses.
  end # method authenticate_user
end # class
