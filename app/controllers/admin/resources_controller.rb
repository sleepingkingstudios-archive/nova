# app/controllers/admin/resources_controller.rb

Dir[Rails.root.join 'app', 'controllers', 'delegates', '**', '*.rb'].each do |file|
  require file
end # each

class Admin::ResourcesController < Admin::AdminController
  include DecoratorsHelper

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

  private

  attr_reader :delegate

  def initialize_delegate
    @delegate = decorate resource_class, :Delegate, :plural => true
    @delegate.controller = self
  end # method initialize_delegate

  def resource_class
    nil
  end # method resource_class

  rescue_from Directory::NotFoundError do |exception|
    flash[:warning] = "Unable to locate directory — #{exception.missing.join('/')} (#{exception.missing.count} total)"

    @directories = exception.found

    redirect_to directory_path(@directories.last)
  end # rescue_from

  rescue_from Nova::AuthenticationError do |exception|
    flash[:warning] = "Unauthorized action"

    redirect_to directory_path(@directories.last)
  end # rescue_from
end # class
