# app/helpers/routes_helper.rb

module RoutesHelper
  include Routes::DirectoryRoutesHelper
  include Routes::ResourceRoutesHelper
  include Routes::BlogRoutesHelper
  include Routes::BlogPostRoutesHelper
  include Routes::PageRoutesHelper
end # module
