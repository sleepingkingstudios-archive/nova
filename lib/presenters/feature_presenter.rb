# lib/presenters/feature_presenter.rb

require 'presenters/presenter'

class FeaturePresenter < Presenter
  alias_method :feature, :object
end # class
