# lib/routers/blog_router.rb

require 'routers/router'

class BlogRouter < Router
  alias_method :blog, :object

  def route_to search, found, missing
    super || route_to_post
  end # method route_to

  private

  def route_to_post
    return unless post = blog.posts.where(:slug => missing.first).first

    @missing = missing[1..-1]
    @found   = found + [post]

    return post if missing.empty?

    nil
  end # method route_to_feature
end # class
