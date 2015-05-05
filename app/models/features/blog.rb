# app/models/features/blog.rb

require 'services/features_enumerator'

class Blog < DirectoryFeature
  FeaturesEnumerator.feature :blog

  ### Relations ###
  has_many :posts, :class_name => 'BlogPost', :validate => false

  ### Instance Methods ###

  def first_published
    BlogPost.first_published(self)
  end # method first_published

  def last_published
    BlogPost.last_published(self)
  end # method last_published
end # model
