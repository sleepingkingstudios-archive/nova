# app/assets/javascripts/layouts/directories/form_layout.js.coffee

class Appleseed.Layouts.Directories.FormLayout extends Appleseed.Layouts.BaseLayout
  @include Appleseed.Layouts.Concerns.SlugFieldAutomation

  @selectors: {
    title_field: '#directory_title'
    slug_field:  '#directory_slug'
  }

  initialize: (root, options) ->
    super(root, options)
