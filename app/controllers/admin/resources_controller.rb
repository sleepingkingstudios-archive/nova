# app/controllers/admin/resources_controller.rb

require 'form_builders/bootstrap_horizontal_form_builder'

require 'errors/resource_not_found_error'

class Admin::ResourcesController < Admin::AdminController
  include Delegation
  include DirectoryLookup

  before_action :lookup_directories, :only => %i(index new create)
  before_action :lookup_resource,    :only => %i(edit update destroy)
  before_action :authenticate_user!
  before_action :initialize_delegate

  rescue_from Directory::NotFoundError,  :with => :handle_missing_directory

  rescue_from Nova::AuthenticationError, :with => :handle_unauthorized_user

  rescue_from Nova::ResourceNotFoundError, :with => :handle_missing_resource

  # GET /path/to/directory/resources
  def index
    delegate.index(request)
  end # action index

  # GET /path/to/directory/resources/new
  def new
    delegate.new(request)
  end # action new

  # POST /path/to/directory/resources
  def create
    delegate.create(request)
  end # action create

  # GET /path/to/resource/edit
  def edit
    delegate.edit(request)
  end # action edit

  # PATCH /path/to/resource
  def update
    delegate.update(request)
  end # action update

  # DELETE /path/to/resource
  def destroy
    delegate.destroy(request)
  end # action destroy

  private

  attr_reader :delegate

  def handle_missing_directory exception = nil
    exception ||= $! # Last exception raised.

    flash[:warning] = "Unable to locate directory — #{exception.missing.join('/')} (#{exception.missing.count} total)"

    redirect_to dashboard_directory_path(@directories.last)
  end # method handle_missing_directory

  def handle_missing_resource exception = nil
    exception ||= $! # Last exception raised.

    flash[:warning] = "Unable to locate directory or feature — #{exception.missing.last}"

    redirect_to dashboard_directory_path(@directories.last)
  end # method handle_missing_resource

  def handle_unauthorized_user exception = nil
    exception ||= $! # Last exception raised.

    flash[:warning] = "Unauthorized action"

    redirect_to directory_path(@directories.last)
  end # method handle_unauthorized_user
end # class
