# app/controllers/delegates/directories_delegate.rb

require 'delegates/resources_delegate'

class DirectoriesDelegate < ResourcesDelegate
  include RoutesHelper

  attr_accessor :directories

  ### Instance Methods ###

  def build_resource_params params
    super(params).merge :parent => directories.last
  end # method build_resource_params

  def resource_params params
    params.permit(:title, :slug)
  end # method resource_params

  ### Routing Methods ###

  def resources_path
    create_directory_path(directories.try(:last))
  end # method resources_path
end # class
