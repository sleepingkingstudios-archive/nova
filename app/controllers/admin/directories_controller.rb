# app/controllers/admin/directories_controller.rb

class Admin::DirectoriesController < Admin::ResourcesController
  include DirectoryLookup

  before_action :lookup_directories
  before_action :authenticate_user!

  # GET /path/to/directory/dashboard
  def dashboard
  end # action dashboard
end # class
