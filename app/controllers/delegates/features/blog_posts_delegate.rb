# app/controllers/delegates/features/blog_posts_delegate.rb

require 'delegates/features_delegate'

class BlogPostsDelegate < FeaturesDelegate
  include ContentBuilding

  def initialize object = nil
    super object || BlogPost

    self.blog = object.try(:blog)
  end # method initialize

  attr_accessor :blog

  ### Instance Methods ###

  def build_resource params
    super

    build_content content_params(request.params), content_type(request.params)

    resource
  end # method build_resource

  def build_resource_params params
    super(params).merge :blog => blog
  end # method build_resource_params

  def content_params params
    params.fetch(:post, {}).fetch(:content, {})
  end # method content_params

  def resource_name
    'posts'
  end # method resource_name

  def update_resource params
    update_content content_params(request.params)

    super
  end # method update_resource

  ### Actions ###

  def show request
    if resource.published? || authorize_user(current_user, :show, resource)
      super
    else
      set_flash_message :warning, "Unable to locate directory or feature — #{resource.slug} (1 total)"

      controller.redirect_to blog_path(blog)
    end # if-else
  end # method show

  def publish request
    self.request = request

    resource.published_at = Time.current

    if resource.save
      set_flash_message :success, flash_message(:publish, :success)

      controller.redirect_to redirect_path(:publish, :success)
    else
      set_flash_message :warning, flash_message(:publish, :failure)
    end # if-else
  end # action publish

  def unpublish request
    self.request = request

    resource.published_at = nil

    # binding.pry

    if resource.save
      set_flash_message :warning, flash_message(:unpublish, :success)

      controller.redirect_to redirect_path(:unpublish, :success)
    else
      set_flash_message :warning, flash_message(:unpublish, :failure)

      controller.redirect_to redirect_path(:unpublish, :failure)
    end # if
  end # action publish

  ### Partial Methods ###

  def index_template_path
    'admin/features/blog_posts/index'
  end # method index_template_path

  def new_template_path
    'admin/features/blog_posts/new'
  end # method new_template_path

  def show_template_path
    'features/blog_posts/show'
  end # method show_template_path

  def edit_template_path
    'admin/features/blog_posts/edit'
  end # method edit_template_path

  private

  def flash_message action, status = nil
    name = resource_class.name.split('::').last

    case "#{action}#{status ? "_#{status}" : ''}"
    when 'create_success'
      'Post successfully created.'
    when 'update_success'
      'Post successfully updated.'
    when 'destroy_success'
      'Post successfully destroyed.'
    when 'publish_success'
      'Post successfully published.'
    when 'publish_failure'
      'Unable to publish post.'
    when 'unpublish_success'
      'Post successfully unpublished.'
    when 'unpublish_failure'
      'Unable to unpublish post.'
    else
      super
    end # case
  end # method flash_message

  def redirect_path action, status = nil
    case "#{action}#{status ? "_#{status}" : ''}"
    when 'destroy_success'
      blog_path(blog)
    else
      super
    end # case
  end # method redirect_path

  ### Routing Methods ###

  def _resource_path
    resource_path(resource)
  end # method _resource_path
end # class
