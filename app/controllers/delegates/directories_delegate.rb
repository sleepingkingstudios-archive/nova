# app/controllers/delegates/directories_delegate.rb

require 'delegates/resources_delegate'

class DirectoriesDelegate < ResourcesDelegate
  include RoutesHelper

  def initialize object = nil
    super object || Directory
  end # method initialize

  ### Instance Methods ###

  def build_resource_params params
    super(params).merge :parent => directories.last
  end # method build_resource_params

  def resource_params params
    params.fetch(:directory, {}).permit(:title, :slug)
  end # method resource_params

  ### Routing Methods ###

  def dashboard_resource_path
    Directory.join directory_path(resource), 'dashboard'
  end # method dashboard_resource_path

  def resources_path
    create_directory_path(directories.try(:last))
  end # method resources_path

  private

  def redirect_path action, status = nil
    case "#{action}#{status ? "_#{status}" : ''}"
    when 'create_success'
      dashboard_resource_path
    when 'update_success'
      dashboard_resource_path
    when 'destroy_success'
      Directory.join directory_path(resource.parent), 'dashboard'
    else
      super
    end # case
  end # method redirect_path
end # class
