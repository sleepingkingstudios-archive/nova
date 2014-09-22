# lib/validators/unique_within_siblings_validator.rb

class UniqueWithinSiblingsValidator < ActiveModel::EachValidator
  attr_reader :attribute, :parent, :record, :value

  def validate_each record, attribute, value
    @record    = record
    @attribute = attribute
    @value     = value

    @parent = case record
    when Directory
      record.parent
    when Feature
      record.directory
    end # case

    if matching_directories.exists? || matching_features.exists?
      record.errors.add(attribute, I18n.t('mongoid.errors.messages.taken'))
    end # if
  end # method validate_each

  private

  def matching_directories
    Directory.where(:parent_id => parent.try(:id), attribute => value).ne(:id => record.id)
  end # method matching_directories

  def matching_features
    Feature.where(:directory_id => parent.try(:id), attribute => value).ne(:id => record.id)
  end # method matching_features
end # class
