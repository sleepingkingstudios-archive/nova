# app/models/settings/navigation_list.rb

class NavigationList
  include Mongoid::Document

  ### Relations ###
  embedded_in :container, :polymorphic => true, :inverse_of => :list
  embeds_many :items, :class_name => 'NavigationListItem', :inverse_of => :list

  ### Validations ###
  validates :container, :presence => true
  validates :items,     :presence => { :if => :validate_presence? }

  ### Instance Methods ###

  def options
    container ? container.options : {}
  end # method options

  def validate_presence?
    !!options[:validate_presence]
  end # method validate_presence?

  def value
    items.map &:value
  end # method value

  def value= params
    items.destroy_all

    params.sort_by { |key, _| key }.each do |_, hsh|
      items.build.value = hsh
    end # each
  end # method value=
end # class
