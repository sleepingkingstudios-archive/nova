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
    params.fetch(:directory, {}).permit(:title, :slug).tap do |permitted|
      if permitted.fetch(:slug, nil).blank?
        permitted.delete :slug
        permitted[:slug_lock] = false
      end # if
    end # tap
  end # method resource_params

  ### Actions ###

  def show request
    scope      = resource ? resource.pages : Page.roots
    index_page = scope.where(:slug => 'index').first

    if index_page.blank?
      super
    elsif !index_page.published? && !authorize_user(current_user, :show, resource)
      super
    else
      assign :resource, index_page

      controller.render page_template_path
    end # if-else
  end # action show

  def export request
    @resource ||= RootDirectory.instance

    super request, :recursive => true, :relations => :all
  end # action request

  ### Partial Methods ###

  def page_template_path
    "features/pages/show"
  end # method page_template_path

  private

  def redirect_path action, status = nil
    case "#{action}#{status ? "_#{status}" : ''}"
    when 'create_success'
      _dashboard_resource_path
    when 'update_success'
      _dashboard_resource_path
    when 'destroy_success'
      Directory.join directory_path(resource.parent), 'dashboard'
    when 'publish_failure'
      _dashboard_resource_path
    when 'unpublish_failure'
      _dashboard_resource_path
    else
      super
    end # case
  end # method redirect_path

  ### Routing Methods ###

  def _dashboard_resource_path
    Directory.join directory_path(resource), 'dashboard'
  end # method _dashboard_resource_path

  def _resources_path
    create_directory_path(directories.try(:last))
  end # method _resources_path
end # class
