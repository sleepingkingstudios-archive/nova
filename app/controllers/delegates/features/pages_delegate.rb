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

    build_content content_params(params)

    resource
  end # method build_resource

  def content_params params
    params.fetch(:page, {}).fetch(:content, {})
  end # method content_params
end # class
