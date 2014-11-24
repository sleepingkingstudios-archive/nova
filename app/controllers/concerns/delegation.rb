# app/controllers/concerns/delegation.rb

Dir[Rails.root.join 'app', 'controllers', 'delegates', '**', '*.rb'].each do |file|
  require file
end # each

module Delegation
  include DecoratorsHelper

  private

  def initialize_delegate
    @delegate = decorate(@resources || @resource || resource_class, :Delegate, :default => :ResourcesDelegate, :plural => true)
    @delegate.controller   = self
    @delegate.current_user = current_user
    @delegate.directories  = @directories || []
  end # method initialize_delegate

  def resource_class
    nil
  end # method resource_class
end # module
