# app/controllers/delegates/features_delegate.rb

require 'delegates/resources_delegate'

class FeaturesDelegate < ResourcesDelegate
  include RoutesHelper

  def initialize object = nil
    super object || Feature
  end # method initialize
end # class
