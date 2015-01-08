# app/models/settings/navigation_list_item.rb

class NavigationListItem
  include Mongoid::Document

  ### Attributes ###
  field :label, :type => String
  field :url,   :type => String

  ### Relations ###
  embedded_in :list, :class_name => 'NavigationList', :inverse_of => :items

  ### Validations ###
  validates :label, :presence => true
  validates :list,  :presence => true

  ### Instance Methods ###

  def value
    { 'label' => label,
      'url'   => url
    } # hash
  end # method value

  def value= params
    params.permit('label', 'url').each do |attribute, value|
      self[attribute] = value
    end # each
  end # method value=
end # class
