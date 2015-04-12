# app/assets/javascripts/layouts/blog_posts/form_layout.js.coffee

class Appleseed.Layouts.Features.BlogPosts.FormLayout extends Appleseed.Layouts.BaseLayout
  @include Appleseed.Layouts.Concerns.ContentSelection
  @include Appleseed.Layouts.Concerns.Previewing
  @include Appleseed.Layouts.Concerns.SlugFieldAutomation

  @selectors: {
    title_field: '#post_title'
    slug_field:  '#post_slug'
    content: {
      sel:      '#content'
      area:     '#content-area'
      error:    '#content-error-notice'
      inputs:   'input, textarea, select'
      loading:  '#content-loading-notice'
      selector: 'select#content_type'
    }
    previewButton: '.preview-button'
  }

  initialize: (root, options) ->
    super(root, options)

    @$form = root.el

  $form = null

  _resourceType: 'blog_post'
