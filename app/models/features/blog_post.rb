# app/models/features/blog_post.rb

require 'mongoid/sleeping_king_studios/orderable'
require 'mongoid/sleeping_king_studios/sluggable'

require 'services/features_enumerator'

class BlogPost < Feature
  include Mongoid::SleepingKingStudios::Orderable
  include Publishing

  FeaturesEnumerator.feature :post, :class => "BlogPost", :parent => :blog

  cache_ordering :published_at.asc,
    :as     => :published_order,
    :filter => ->() { where(:published_at.lte => Time.current) },
    :scope  => :blog_id

  ### Relations ###
  belongs_to :blog, :inverse_of => :posts

  embeds_one :content, :as => :container

  ### Validations ###
  validates :blog,    :presence => true
  validates :content, :presence => true
  validates :slug,    :uniqueness => { :scope => :blog }

  ### Instance Methods ###

  def first_published
    @first_published ||= BlogPost.first_published(blog)
  end # method first_published

  def last_published
    @last_published ||= BlogPost.last_published(blog)
  end # method last_published

  def next_published
    @next_published ||= super
  end # method next_published

  def prev_published
    @prev_published ||= super
  end # method prev_published

  def to_partial_path
    return '/' if blog.blank?

    Directory.join(*[blog.to_partial_path, slug].reject { |slug| slug.blank? })
  end # method to_partial_path
end # class
