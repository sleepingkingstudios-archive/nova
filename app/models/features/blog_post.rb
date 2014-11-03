# app/models/features/blog_post.rb

require 'mongoid/sleeping_king_studios/sluggable'

class BlogPost < Feature
  ### Relations ###
  belongs_to :blog, :inverse_of => :posts

  embeds_one :content, :as => :container

  ### Validations ###
  validates :blog,    :presence => true
  validates :content, :presence => true
  validates :slug,    :uniqueness => { :scope => :blog }
end # class
