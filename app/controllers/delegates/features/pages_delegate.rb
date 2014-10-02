# app/controllers/delegates/features/pages_delegate.rb

require 'delegates/features_delegate'

class PagesDelegate < FeaturesDelegate
  include ContentBuilding

  def initialize object = nil
    super object || Page
  end # method initialize

  ### Instance Methods ###

  def build_resource params
    super

    build_content content_params(request.params), request.try(:params).try(:[], :content_type)

    resource
  end # method build_resource

  def build_resource_params params
    super(params).merge :directory => directories.try(:last)
  end # method build_resource_params

  def content_params params
    params.fetch(:page, {}).fetch(:content, {})
  end # method content_params
end # class
