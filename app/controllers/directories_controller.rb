# app/controllers/directories_controller.rb

class DirectoriesController < ApplicationController
  include DirectoryLookup

  before_action :lookup_directories, :only => %i(show)

  # GET /path/to/directory
  def show
    @current_directory = @directories.last
  end # action show

  rescue_from Directory::NotFoundError do |exception|
    flash.now[:warning] = "Unable to locate directory — #{exception.missing.join('/')} (#{exception.missing.count} total)"

    @directories       = exception.found
    @current_directory = @directories.last

    render :show
  end # rescue_from
end # controller
