# app/helpers/application_helper.rb

module ApplicationHelper
  include DecoratorsHelper
  include Decorators::PresentersHelper
  include Decorators::SerializersHelper
  include IconsHelper
  include RenderingHelper
end # module
