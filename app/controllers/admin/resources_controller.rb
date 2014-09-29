# app/controllers/admin/resources_controller.rb

Dir[Rails.root.join 'app', 'controllers', 'delegates', '**', '*.rb'].each do |file|
  require file
end # each

class Admin::ResourcesController < Admin::AdminController
  include DecoratorsHelper
  include DirectoryLookup

  before_action :lookup_directories, :only => %i(index new create)
  before_action :lookup_resource,    :only => %i(edit update destroy)
  before_action :authenticate_user!
  before_action :initialize_delegate

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

    @directories = exception.found

    begin
      authenticate_user!
    rescue Nova::AuthenticationError
      handle_unauthorized_user and return
    end # begin-rescue

    flash[:warning] = "Unable to locate directory — #{exception.missing.join('/')} (#{exception.missing.count} total)"

    redirect_to dashboard_directory_path(@directories.last)
  end # method handle_missing_directory

  def handle_unauthorized_user exception = nil
    exception ||= $! # Last exception raised.

    flash[:warning] = "Unauthorized action"

    redirect_to directory_path(@directories.last)
  end # method handle_unauthorized_user

  def initialize_delegate
    @delegate = decorate(@resources || @resource || resource_class, :Delegate, :plural => true)
    @delegate.controller  = self
    @delegate.directories = @directories
  end # method initialize_delegate

  def lookup_resource
    # First, see if the entire path refers to a chain of directories. If so,
    # the last directory found will be our resource.

    lookup_directories

    @resource = @directories.last
  rescue Directory::NotFoundError => exception
    # If we're missing more than one path segment, there's at least one
    # directory missing.
    raise if exception.missing.count > 1

    @directories = exception.found

    begin
      authenticate_user!
    rescue Nova::AuthenticationError
      handle_unauthorized_user and return
    end # begin-rescue

    # Otherwise, we'll check the last directory found for a feature matching
    # the one missing segment.
    scope        = @directories.blank? ? Feature.roots : @directories.last.features
    features     = scope.where(:slug => exception.missing.last)

    # If the result is blank, flash a warning and redirect to the directory page.
    if features.blank?
      flash[:warning] = "Unable to locate directory or feature — #{exception.missing.last}"

      redirect_to dashboard_directory_path(@directories.last)
    end # if

    @resource = features.last
  end # method lookup_resource

  def resource_class
    nil
  end # method resource_class

  rescue_from Directory::NotFoundError,  :with => :handle_missing_directory

  rescue_from Nova::AuthenticationError, :with => :handle_unauthorized_user
end # class
