# app/models/features/content.rb

class Content
  include Mongoid::Document

  ### Relations ###
  embedded_in :container, :polymorphic => true

  ### Validation ###
  validates :container, :presence => true
end # class
