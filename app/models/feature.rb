# app/models/feature.rb

class Feature
  include Mongoid::Document

  belongs_to :directory
end # model
