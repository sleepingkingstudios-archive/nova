# app/controllers/admin/registrations_controller.rb

require 'form_builders/bootstrap_horizontal_form_builder'

class Admin::RegistrationsController < Devise::RegistrationsController
  # GET /admin/users/register
  def new
    redirect_to :root
  end # action new

  # POST /admin/users
  def create
    head 403
  end # action create
end # controller
