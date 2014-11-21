# spec/support/models/example_feature.rb

module Spec
  module Models
    class ExampleFeature < DirectoryFeature
      field :example_field, :type => String

      validates :example_field, :presence => true
    end # class
  end # module
end # module
