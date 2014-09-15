# app/models/features/page.rb

class Page < Feature

  ### Relations ###
  embeds_one :content, :as => :container

  ### Validations ###
  validates :content, :presence => true
end # model
