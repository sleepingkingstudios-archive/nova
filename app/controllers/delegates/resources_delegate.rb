# app/controllers/delegates/resources_delegate.rb

class ResourcesDelegate
  include Decorators::SerializersHelper

  def initialize object
    case object
    when Class
      @resource_class = object
    when Array
      @resource_class = object.first.class
      @resources      = object
    else
      @resource_class = object.class
      @resource       = object
    end # when
  end # constructor

  attr_accessor :controller, :current_user, :directories, :request

  attr_reader :resource, :resources, :resource_class

  ### Instance Methods ###

  def assign key, value
    key = key =~ /\A@/ ? key : "@#{key}"

    controller.instance_variable_set key, value
  end # method assign

  def authorize_user user, action, resource
    !user.blank?
  end # method authorize_user

  def build_resource params
    @resources = nil
    @resource  = resource_class.new params
  end # method build_resource

  def build_resource_params params
    resource_params params
  end # method build_resource_params

  def load_resources
    @resource  = nil
    @resources = resource_class.all
  end # method load_resources

  def resource_name
    resource_class.name.to_s.tableize
  end # method resource_name

  def resource_params params
    params.fetch(resource_name.singularize, {}).permit()
  end # method resource_params

  def set_flash_message key, message, options = {}
    return if message.blank?

    flash = options.fetch(:now, false) ? controller.flash.now : controller.flash

    flash[key] = message
  end # method set_flash_message

  def update_resource params
    resource.update params
  end # method update_resource

  def update_resource_params params
    resource_params params
  end # method update_resource_params

  ### Actions ###

  def index request
    self.request = request

    assign :resources, load_resources

    controller.render index_template_path
  end # action index

  def new request
    self.request = request

    params = ActionController::Parameters.new(request.params)
    assign :resource, build_resource(build_resource_params params)

    controller.render new_template_path
  end # action new

  def preview request
    self.request = request

    params = ActionController::Parameters.new(request.params)
    assign :resource, build_resource(build_resource_params params)

    controller.render show_template_path
  end # action preview

  def create request
    self.request = request

    params = ActionController::Parameters.new(request.params)
    assign :resource, build_resource(build_resource_params params)

    if resource.save
      set_flash_message :success, flash_message(:create, :success)

      controller.redirect_to redirect_path(:create, :success)
    else
      set_flash_message :warning, flash_message(:create, :failure), :now => true

      controller.render new_template_path
    end # if-else
  end # action create

  def show request
    self.request = request

    assign :resource, resource

    controller.render show_template_path
  end # action show

  def edit request
    self.request = request

    assign :resource, resource

    controller.render edit_template_path
  end # action edit

  def update request
    self.request = request

    params = ActionController::Parameters.new(request.params)
    assign :resource, resource

    if update_resource update_resource_params(params)
      set_flash_message :success, flash_message(:update, :success)

      controller.redirect_to redirect_path(:update, :success)
    else
      set_flash_message :warning, flash_message(:update, :failure), :now => true

      controller.render edit_template_path
    end # if-else
  end # action update

  def destroy request
    self.request = request

    resource.destroy

    set_flash_message :danger, flash_message(:destroy, :success)

    controller.redirect_to redirect_path(:destroy, :success)
  end # action destroy

  def publish request
    self.request = request

    set_flash_message :warning, flash_message(:publish, :failure)

    controller.redirect_to redirect_path(:publish, :failure)
  end # action publish

  def unpublish request
    self.request = request

    set_flash_message :warning, flash_message(:unpublish, :failure)

    controller.redirect_to redirect_path(:unpublish, :failure)
  end # action publish

  def export request, **options
    self.request = request

    serialized = resources.blank? ? serialize(resource, **options) : resources.map { |resource| serialize(resource, **options) }

    controller.render :json => JsonExporter.export(serialized, :pretty => request.params[:pretty] == 'true')
  end # action show

  ### Partial Methods ###

  def index_template_path
    "admin/#{resource_name}/index"
  end # method index_template_path

  def new_template_path
    "admin/#{resource_name}/new"
  end # method new_template_path

  def show_template_path
    "#{resource_name}/show"
  end # method show_template_path

  def edit_template_path
    "admin/#{resource_name}/edit"
  end # method edit_template_path

  ### Routing Methods ###

  private

  def flash_message action, status = nil
    name = resource_class.name.split('::').last

    case "#{action}#{status ? "_#{status}" : ''}"
    when 'create_success'
      "#{name} successfully created."
    when 'update_success'
      "#{name} successfully updated."
    when 'destroy_success'
      "#{name} successfully destroyed."
    when 'publish_success'
      "#{name} successfully published."
    when 'unpublish_success'
      "#{name} successfully unpublished."
    when 'publish_failure'
      "Unable to publish #{name.downcase}."
    when 'unpublish_failure'
      "Unable to unpublish #{name.downcase}."
    end # case
  end # method flash_message

  def redirect_path action, status = nil
    case "#{action}#{status ? "_#{status}" : ''}"
    when 'create_success'
      _resource_path
    when 'update_success'
      _resource_path
    when 'destroy_success'
      _index_resources_path
    when 'publish_success'
      _resource_path
    when 'publish_failure'
      _resource_path
    when 'unpublish_success'
      _resource_path
    when 'unpublish_failure'
      _resource_path
    end # case
  end # method redirect_path

  ### Routing Methods ###

  def _create_resource_path
    _resources_path
  end # method _create_resource_path

  def _index_resources_path
    _resources_path
  end # method _index_resources_path

  def _resource_path object = nil
    resource_id = case
    when object.blank?
      resource.try(:id)
    when object.respond_to?(:id)
      object.id
    else
      object.to_s
    end # case

    "#{_resources_path}/#{resource_id}"
  end # method _resource_path

  def _resources_path
    resource_name
  end # method _resources_path
end # class
