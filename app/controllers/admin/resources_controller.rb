# app/controllers/admin/resources_controller.rb

class Admin::ResourcesController < Admin::AdminController
  # GET /path/to/directory/resources
  def index
  end # action index

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
