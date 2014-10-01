# app/controllers/admin/admin_controller.rb

class Admin::AdminController < ApplicationController
  def authenticate_user!
    super

    raise Appleseed::AuthenticationError.new(request) unless user_signed_in?
  end # method authenticate_user  
end # class
