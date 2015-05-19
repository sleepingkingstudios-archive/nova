# app/helpers/decorators/presenters_helper.rb

Dir[Rails.root.join 'lib', 'presenters', '**', '*presenter.rb'].each do |file|
  require file
end # each

module Decorators
  module PresentersHelper
    include DecoratorsHelper

    def present object
      decorate object, :presenter
    end # method present
  end # module
end # module
