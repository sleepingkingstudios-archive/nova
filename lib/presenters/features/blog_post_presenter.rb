# lib/presenters/features/blog_post_presenter.rb

require 'presenters/feature_presenter'

class BlogPostPresenter < FeaturePresenter
  alias_method :post, :feature

  delegate :blog, :to => :post
end # class
