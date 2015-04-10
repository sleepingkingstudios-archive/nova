# app/models/features/directory_feature.rb

require 'validators/unique_within_siblings_validator'

class DirectoryFeature < Feature
  def self.inherited subclass
    super

    subclass.scope :roots, ->() {
      where(:directory_id => nil, :_type => subclass.name)
    } # end lambda
  end # class method inherited

  ### Class Methods ###
  scope :roots, ->() {
    classes = FeaturesEnumerator.directory_features.map { |_, hsh| hsh[:class] }

    classes << 'DirectoryFeature'

    where(:directory_id => nil, :_type.in => classes)
  } # end lambda

  ### Relations ###
  belongs_to :directory, :inverse_of => :features

  ### Validations ###
  validates :slug, :unique_within_siblings => true

  ### Instance Methods ###

  def to_partial_path
    directory ?
      Directory.join(*[directory.to_partial_path, slug].reject { |slug| slug.blank? }) :
      slug
  end # method to_partial_path
end # class
