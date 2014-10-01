# app/controllers/resources_controller.rb

class ResourcesController < ApplicationController
  include Delegation
  include DirectoryLookup

  before_action :lookup_resource, :only => %i(show)
  before_action :initialize_delegate

  rescue_from Nova::ResourceNotFoundError, :with => :handle_missing_resource

  # GET /path/to/resource
  def show
    delegate.show(request)
  end # action show

  private

  attr_reader :delegate
  
  def handle_missing_resource exception = nil
    exception ||= $! # Last exception raised.

    flash[:warning] = "Unable to locate directory or feature — #{exception.missing.last}"

    redirect_to directory_path(@directories.last)
  end # method handle_missing_resource

  def resource_class
    # Default to Directory when viewing root path.
    params[:directories].try(:split, '/').blank? ? Directory : super
  end # method resource_class
end # class
