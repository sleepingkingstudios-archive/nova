# app/controllers/admin/directories_controller.rb

class Admin::DirectoriesController < Admin::ResourcesController
  include DirectoryLookup

  before_action :lookup_directories
  before_action :authenticate_user!

  # GET /path/to/directory/dashboard
  def dashboard
  end # action dashboard

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
