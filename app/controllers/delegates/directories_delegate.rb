# app/controllers/delegates/directories_delegate.rb

require 'delegates/resources_delegate'

class DirectoriesDelegate < ResourcesDelegate
  include RoutesHelper
  include TextHelper

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

  def dashboard request
    controller.render dashboard_template_path
  end # action show

  def export request
    @resource ||= RootDirectory.instance

    super request, :recursive => true, :relations => :all
  end # action export

  def import request
    @resource ||= RootDirectory.instance

    feature_type = case request.params[:feature_type]
    when 'feature', 'directory'
      request.params[:feature_type]
    else
      'feature'
    end # case

    if request.params[:feature].blank?
      set_flash_message :error, flash_message(:import, :failure, feature_type)

      if feature_type == 'directory'
        template_path = import_directory_template_path
        resource      = Directory.new
        resource.errors[:base] << "Directory can't be blank"
      else
        template_path = import_feature_template_path
        resource      = Feature.new
        resource.errors[:base] << "Feature can't be blank"
      end

      assign :resource, resource

      controller.render template_path

      return
    end # if

    allowed_formats = %w(json yaml)
    case (format = request.params[:format])
    when *allowed_formats
      exporter = Object.new.extend ExportersHelper

      begin
        exporter.import request.params[:feature], :format => format
      rescue ArgumentError => exception
        set_flash_message :error, flash_message(:import, :failure, feature_type)

        if feature_type == 'directory'
          template_path = import_directory_template_path
          resource      = Directory.new
        else
          template_path = import_feature_template_path
          resource      = Feature.new
        end # if-else

        if exception.message == 'must specify a type'
          resource.errors[:type] << "can't be blank"
        else
          resource.errors[:base] << "#{feature_type.capitalize} is invalid"
        end # if-else

        assign :resource, resource

        controller.render template_path

        return
      rescue Appleseed::ImportError => exception
        set_flash_message :error, flash_message(:import, :failure, feature_type)

        if feature_type == 'directory'
          template_path = import_directory_template_path
          resource      = Directory.new
        else
          template_path = import_feature_template_path
          resource      = Feature.new
        end # if-else

        resource.errors[:base] << "#{format.upcase} is malformed"

        assign :resource, resource

        controller.render template_path

        return
      end # rescue
    else
      set_flash_message :error, flash_message(:import, :failure, feature_type)

      format_message = if format.blank?
        "Format can't be blank"
      else
        format_string = "#{humanize_list allowed_formats, :last_separator => ' or '}"
        "Format must be #{format_string}, but was #{format.blank? ? 'blank' : format}"
      end

      if feature_type == 'directory'
        template_path = import_directory_template_path
        resource      = Directory.new
      else
        template_path = import_feature_template_path
        resource      = Feature.new
      end

      resource.errors[:base] << format_message

      assign :resource, resource

      controller.render template_path

      return
    end # case
  end # action import

  def import_directory request
    controller.render import_directory_template_path
  end # action import_directory

  def import_feature request
    controller.render import_feature_template_path
  end # action import_directory

  ### Partial Methods ###

  def dashboard_template_path
    "admin/directories/dashboard"
  end # method edit_template_path

  def import_directory_template_path
    "admin/directories/import"
  end # method edit_template_path

  def import_feature_template_path
    "admin/features/import"
  end # method edit_template_path

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

  def flash_message action, status = nil, resource_type = 'feature'
    name = resource_class.name.split('::').last

    case "#{action}#{status ? "_#{status}" : ''}"
    when 'import_success'
      "#{resource_type.capitalize} successfully created."
    when 'import_failure'
      "Unable to import #{resource_type}."
    else
      super action, status
    end # case
  end # method flash_message

  def _dashboard_resource_path
    Directory.join directory_path(resource), 'dashboard'
  end # method _dashboard_resource_path

  def _resources_path
    create_directory_path(directories.try(:last))
  end # method _resources_path
end # class
