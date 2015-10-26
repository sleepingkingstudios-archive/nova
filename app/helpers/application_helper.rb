# app/helpers/application_helper.rb

module ApplicationHelper
  include DecoratorsHelper
  include Decorators::PresentersHelper
  include Decorators::SerializersHelper
  include ExportersHelper
  include IconsHelper
  include RenderingHelper
  include TextHelper
end # module
