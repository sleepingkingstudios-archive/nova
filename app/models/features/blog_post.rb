# app/models/features/blog_post.rb

require 'mongoid/sleeping_king_studios/sluggable'

class BlogPost
  include Mongoid::Document
  include Mongoid::SleepingKingStudios::Sluggable

  ### Class Methods ###

  class << self
    def default_content_type
      :text
    end # method default_content_type

    def reserved_slugs
      Feature.reserved_slugs
    end # class method reserved_slugs
  end # class << self

  ### Attributes ###
  field :title, :type => String

  ### Concerns ###
  slugify :title, :lockable => true

  ### Relations ###
  belongs_to :blog, :inverse_of => :posts

  embeds_one :content, :as => :container

  ### Validations ###
  validates :blog,    :presence => true
  validates :content, :presence => true
  validates :title,   :presence => true
  validates :slug,
    :exclusion  => { :in => ->(document) { document.class.reserved_slugs } },
    :uniqueness => { :scope => :blog }
end # class
