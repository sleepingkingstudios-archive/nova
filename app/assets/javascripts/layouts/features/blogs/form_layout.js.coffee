# app/assets/javascripts/layouts/blogs/form_layout.js.coffee

class Appleseed.Layouts.Features.Blogs.FormLayout extends Appleseed.Layouts.BaseLayout
  @include Appleseed.Layouts.Concerns.SlugFieldAutomation

  @selectors: {
    title_field: '#blog_title'
    slug_field:  '#blog_slug'
  }

  initialize: (root, options) ->
    super(root, options)
