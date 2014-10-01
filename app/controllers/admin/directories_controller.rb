# app/controllers/admin/directories_controller.rb

class Admin::DirectoriesController < Admin::ResourcesController
  # When creating a filter, Rails removes other filters with the same name,
  # even if they have different filtering options. As a workaround, we're
  # invoking the method through a block.
  prepend_before_action(:only => %i(dashboard)) { lookup_directories }

  after_action :assign_directory, :only => %w(create new edit update)

  # GET /path/to/directory/dashboard
  def dashboard
  end # action dashboard

  private

  def assign_directory
    @directory = @resource
  end # method assign_directory

  def resource_class
    :directory
  end # method resource_class
end # class
