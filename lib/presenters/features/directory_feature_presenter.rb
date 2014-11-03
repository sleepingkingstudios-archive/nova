# lib/presenters/features/directory_feature_presenter.rb

require 'presenters/feature_presenter'

class DirectoryFeaturePresenter < FeaturePresenter
  delegate :directory, :to => :feature
end # class
