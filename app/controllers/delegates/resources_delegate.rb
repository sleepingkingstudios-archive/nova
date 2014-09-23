# app/controllers/delegates/resources_delegate.rb

class ResourcesDelegate
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

  attr_accessor :controller

  attr_reader :resource, :resources, :resource_class

  ### Instance Methods ###

  def assign key, value
    key = key =~ /\A@/ ? key : "@#{key}"

    controller.instance_variable_set key, value
  end # method assign

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
    params.permit()
  end # method resource_params

  ### Actions ###

  def index request
    assign :resources, load_resources

    controller.render index_template_path
  end # action index

  def new request
    params = ActionController::Parameters.new(request.params)
    assign :resource, build_resource(build_resource_params params)

    controller.render new_template_path
  end # action new

  ### Partial Methods ###

  def index_template_path
    "admin/#{resource_name}/index"
  end # method index_template_path

  def new_template_path
    "admin/#{resource_name}/new"
  end # method new_template_path

  ### Routing Methods ###

  def resource_path object = nil
    resource_id = case
    when object.blank?
      resource.try(:id)
    when object.respond_to?(:id)
      object.id
    else
      object.to_s
    end # case

    "#{resources_path}/#{resource_id}"
  end # method resource_path

  def resources_path
    resource_name
  end # method resource_path
end # class
