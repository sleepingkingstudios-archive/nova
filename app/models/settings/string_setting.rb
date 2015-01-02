# app/models/settings/string_setting.rb

class StringSetting < Setting
  ### Attributes ###
  field :value, :type => String

  ### Validations ###
  validates :value, :presence => { :if => :validate_presence? }
end # class
