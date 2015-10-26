# app/controllers/admin/features/imports_controller.rb

class Admin::Features::ImportsController < Admin::ResourcesController
  # GET /path/to/directory/features/import/new
  def new
    delegate.new(request)
  end # action new

  private

  def build_delegate
    Features::ImportsDelegate.new(@resources || @resource)
  end # method build_delegate

  def resource_class
    :feature
  end # method resource_class
end # class
