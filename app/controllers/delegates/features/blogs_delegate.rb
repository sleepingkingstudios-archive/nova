# app/controllers/delegates/features/blogs_delegate.rb

require 'delegates/features/directory_features_delegate'

class BlogsDelegate < DirectoryFeaturesDelegate
  def initialize object = nil
    super object || Blog
  end # method initialize

  ### Actions ###

  def export request
    super request, :relations => :all
  end # action request
end # class
