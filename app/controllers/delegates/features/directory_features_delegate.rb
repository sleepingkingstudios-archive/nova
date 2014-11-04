# app/controllers/delegates/features/directory_features_delegate.rb

require 'delegates/features_delegate'

class DirectoryFeaturesDelegate < FeaturesDelegate
  def initialize object = nil
    super object || DirectoryFeature
  end # method initialize

  ### Instance Methods ###

  def build_resource_params params
    super(params).merge :directory => directories.try(:last)
  end # method build_resource_params

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
