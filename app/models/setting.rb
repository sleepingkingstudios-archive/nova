# app/models/setting.rb

class Setting
  include Mongoid::Document
  include Mongoid::Timestamps

  ### Attributes ###
  field :key,               :type => String
  field :value,             :type => Object
  field :validate_presence, :type => Boolean

  ### Validations ###
  validates :key, :presence => true, :uniqueness => true

  validates :value, :presence => { :if => :validate_presence? }
end # class
