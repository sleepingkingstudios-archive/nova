# app/models/features/page.rb

require 'mongoid/sleeping_king_studios/sluggable'

class Page < Feature
  include Mongoid::SleepingKingStudios::Sluggable

  ### Attributes ###
  field :title, :type => String

  ### Concerns ###
  slugify :title, :lockable => true

  ### Relations ###
  embeds_one :content, :class_name => "PageContent"

  ### Validations ###
  validates :content, :presence => true
  validates :title,   :presence => true
end # model
