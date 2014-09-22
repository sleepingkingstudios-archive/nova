# app/helpers/presenters_helper.rb

Dir[Rails.root.join 'lib', 'presenters', '**', '*presenter.rb'].each do |file|
  require file
end # each

module PresentersHelper
  def present object
    klass = object.class

    while klass != Object && klass != nil
      begin
        presenter = "#{klass.name}Presenter".constantize

        return presenter.new(object)
      rescue NameError => exception
        klass = klass.superclass
      end # begin-rescue
    end # while

    Presenter.new(object)
  end # method present
end # module
