# app/controllers/delegates/features/pages_delegate.rb

require 'delegates/features/directory_features_delegate'

class PagesDelegate < DirectoryFeaturesDelegate
  include ContentBuilding

  def initialize object = nil
    super object || Page
  end # method initialize

  ### Instance Methods ###

  def build_resource params
    super

    build_content content_params(request.params), content_type(request.params)

    resource
  end # method build_resource

  def content_params params
    params.fetch(:page, {}).fetch(:content, {})
  end # method content_params

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

      controller.redirect_to directory_path(directories.last)
    end # if-else
  end # method show

  def publish request
    self.request = request

    resource.set(:published_at => Time.current)

    set_flash_message :success, flash_message(:publish, :success)

    controller.redirect_to redirect_path(:publish, :success)
  end # action publish

  def unpublish request
    self.request = request

    resource.set(:published_at => nil)

    set_flash_message :warning, flash_message(:unpublish, :success)

    controller.redirect_to redirect_path(:unpublish, :success)
  end # action publish
end # class
