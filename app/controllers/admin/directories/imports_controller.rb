# app/controllers/admin/directories/imports_controller.rb

class Admin::Directories::ImportsController < Admin::ResourcesController
  # GET /path/to/directory/directories/import/new
  def new
    delegate.new(request)
  end # action new

  private

  def build_delegate
    Directories::ImportsDelegate.new(@resources || @resource)
  end # method build_delegate

  def resource_class
    :directory
  end # method resource_class
end # class
