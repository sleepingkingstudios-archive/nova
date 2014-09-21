# app/controllers/directories_controller.rb

require 'presenters/directory_presenter'

class DirectoriesController < ApplicationController
  include DirectoryLookup

  before_action :lookup_directories
  before_action :authenticate_user!, :except => %i(show)

  # GET /path/to/directory
  def show
    @current_directory = @directories.last
  end # action show

  # GET /path/to/directory/index
  def index
    @current_directory = @directories.last
  end # action index

  private

  rescue_from Directory::NotFoundError do |exception|
    flash[:warning] = "Unable to locate directory — #{exception.missing.join('/')} (#{exception.missing.count} total)"

    @directories       = exception.found
    @current_directory = @directories.last

    redirect_to directories_path(@directories)
  end # rescue_from

  rescue_from Nova::AuthenticationError do |exception|
    flash[:warning] = "Unauthorized action"

    redirect_to directories_path(@directories)
  end # rescue_from
end # controller
