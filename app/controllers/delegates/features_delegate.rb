# app/controllers/delegates/features_delegate.rb

require 'delegates/resources_delegate'

class FeaturesDelegate < ResourcesDelegate
  include RoutesHelper

  def initialize object = nil
    super object || Feature
  end # method initialize

  ### Instance Methods ###

  def resource_params params
    params.fetch(resource_name.singularize, {}).permit(:title, :slug).tap do |permitted|
      if permitted.fetch(:slug, nil).blank?
        permitted.delete :slug
        permitted[:slug_lock] = false
      end # if
    end # tap
  end # method resource_params

  ### Partial Methods ###

  def index_template_path
    "admin/features/#{resource_name}/index"
  end # method index_template_path

  def new_template_path
    "admin/features/#{resource_name}/new"
  end # method new_template_path

  def show_template_path
    "features/#{resource_name}/show"
  end # method show_template_path

  def edit_template_path
    "admin/features/#{resource_name}/edit"
  end # method edit_template_path

  private

  def redirect_path action, status = nil
    case "#{action}#{status ? "_#{status}" : ''}"
    when 'destroy_success'
      dashboard_directory_path(directories.last)
    else
      super
    end # case
  end # method redirect_path

  ### Routing Methods ###

  def _resource_path
    resource_path(resource)
  end # method _resource_path
end # class
