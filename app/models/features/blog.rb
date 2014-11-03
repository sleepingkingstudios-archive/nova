# app/models/features/blog.rb

require 'services/features_enumerator'

class Blog < Feature
  FeaturesEnumerator.feature :blog

  ### Relations ###
  has_many :posts, :class_name => 'BlogPost'
end # model
