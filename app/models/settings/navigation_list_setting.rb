# app/models/settings/navigation_list_setting.rb

class NavigationListSetting < Setting
  ### Relations ###
  embeds_one :list, :class_name => 'NavigationList', :as => :container

  ### Validations ###
  validates :list, :presence => { :if => :validate_presence? }

  ### Instance Methods ###

  def value
    list ? list.value : []
  end # method value
end # class
