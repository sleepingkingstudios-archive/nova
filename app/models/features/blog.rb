# app/models/features/blog.rb

require 'services/features_enumerator'

class Blog < Feature
  FeaturesEnumerator.feature :blog
end # model
