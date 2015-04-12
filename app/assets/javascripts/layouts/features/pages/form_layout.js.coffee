# subl app/assets/javascripts/layouts/features/pages/form_layout.js.coffee

class Appleseed.Layouts.Features.Pages.FormLayout extends Appleseed.Layouts.BaseLayout
  @include Appleseed.Layouts.Concerns.ContentSelection
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

    @get('previewButton').on 'click', @previewButtonClicked

  $form = null

  _resourceType: 'page'

  ### Event Handlers ###

  previewButtonClicked: (event) =>
    event.preventDefault();

    action = @$form.attr('action')
    target = @$form.attr('target')

    @$form.attr('action', action + '/preview')
    @$form.attr('target', '_blank')

    @$form.submit();

    @$form.attr('action', action)
    @$form.attr('target', target)

  previewPageFailure: (xhr, status, error) =>
    console.log 'Pages.FormLayout#previewPageFailure(): ' + error
    console.log xhr.responseText

  previewFormSuccess: (data, status, xhr) =>
    console.log 'Pages.FormLayout#previewPageSuccess'

    w = window.open('about:blank', 'windowname');
    w.document.write(data);
    w.document.close();
