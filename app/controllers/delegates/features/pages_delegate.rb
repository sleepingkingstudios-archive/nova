# app/controllers/delegates/features/pages_delegate.rb

require 'delegates/features_delegate'

class PagesDelegate < FeaturesDelegate
  def initialize object = nil
    super object || Page
  end # method initialize
end # class
