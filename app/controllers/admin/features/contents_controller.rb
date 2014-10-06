# app/controllers/admin/features/contents_controller.rb

require 'form_builders/bootstrap_horizontal_form_builder'

class Admin::Features::ContentsController < Admin::AdminController
  include DecoratorsHelper

  before_action :authenticate_user!
  before_action :require_xhr!

  rescue_from Appleseed::AuthenticationError, :with => :handle_unauthorized_user

  # GET /admin/contents/:content_type/fields
  def fields
    @content_type  = params.fetch(:content_type, '').to_s.camelize.sub(/Content(s?)\z/, '') << "Content"
    @resource_type = params.fetch(:resource_type, 'resource').to_s.underscore

    render :layout => false
  end # action fields

  private

  def handle_unauthorized_user exception = nil
    exception ||= $! # Last exception raised.

    flash[:warning] = "Unauthorized action"

    redirect_to root_path
  end # method handle_unauthorized_user

  def require_xhr!
    raise Appleseed::AuthenticationError.new(request) unless request.xhr?
  end # method require_xhr!
end # class
