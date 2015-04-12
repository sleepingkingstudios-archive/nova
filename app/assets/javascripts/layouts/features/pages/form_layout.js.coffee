# subl app/assets/javascripts/layouts/features/pages/form_layout.js.coffee

class Appleseed.Layouts.Features.Pages.FormLayout extends Appleseed.Layouts.BaseLayout
  @include Appleseed.Layouts.Concerns.ContentSelection
  @include Appleseed.Layouts.Concerns.Previewing
  @include Appleseed.Layouts.Concerns.SlugFieldAutomation

  @selectors: {
    title_field: '#page_title'
    slug_field:  '#page_slug'
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

  _resourceType: 'page'
