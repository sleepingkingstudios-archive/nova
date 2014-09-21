# lib/presenters/presenter.rb

class Presenter
  include ActionView::Helpers
  include Rails.application.routes.url_helpers

  def initialize object
    @object = object
  end # constructor

  attr_reader :object

  private

  def empty_value
    content_tag(:span, '(none)', :class => 'text-muted')
  end # method empty_value
end # class
