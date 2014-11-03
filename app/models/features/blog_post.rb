# app/models/features/blog_post.rb

require 'mongoid/sleeping_king_studios/sluggable'

require 'services/features_enumerator'

class BlogPost < Feature
  FeaturesEnumerator.feature :post, :class => "BlogPost", :parent => :blog

  ### Relations ###
  belongs_to :blog, :inverse_of => :posts

  embeds_one :content, :as => :container

  ### Validations ###
  validates :blog,    :presence => true
  validates :content, :presence => true
  validates :slug,    :uniqueness => { :scope => :blog }

  ### Instance Methods ###

  def to_partial_path
    return '/' if blog.blank?

    Directory.join(*[blog.to_partial_path, slug].reject { |slug| slug.blank? })
  end # method to_partial_path
end # class
