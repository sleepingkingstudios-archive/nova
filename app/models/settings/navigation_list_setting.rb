# app/models/settings/navigation_list_setting.rb

class NavigationListSetting < Setting
  ### Relations ###
  embeds_one :list, :class_name => 'NavigationList', :as => :container, :validate => false

  ### Validations ###
  class ListValidator < ActiveModel::Validator
    attr_accessor :record, :list, :items

    def validate record
      @record = record
      @list   = record.list
      @items  = record.list.try(:items) || []

      record.errors.add :list, "can't be blank" if record.validate_presence? && (list.blank? || items.blank?)

      items.each.with_index do |item, index|
        next if item.valid?

        item.errors.each do |attribute, message|
          record.errors.add "Item #{index+1}'s #{attribute}", message
        end # each
      end # each
    end # method validate
  end # class

  validates :list, :presence => { :if => :validate_presence? }
  validates_with ListValidator

  ### Instance Methods ###

  def value
    list ? list.value : []
  end # method value
end # class
