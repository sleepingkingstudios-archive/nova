# app/controllers/admin/directories_controller.rb

class Admin::DirectoriesController < Admin::ResourcesController
  include DirectoryLookup

  prepend_before_action :authenticate_user!
  prepend_before_action :lookup_directories

  after_action :assign_directory, :only => %w(create new edit update)

  # GET /path/to/directory/dashboard
  def dashboard
  end # action dashboard

  private

  def assign_directory
    @directory = @resource
  end # method assign_directory

  def initialize_delegate
    super

    delegate.directories = @directories
  end # method initialize_delegate

  def resource_class
    :directory
  end # method resource_class
end # class
