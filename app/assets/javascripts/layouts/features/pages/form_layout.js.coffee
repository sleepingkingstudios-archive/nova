# subl app/assets/javascripts/layouts/features/pages/form_layout.js.coffee

class Appleseed.Layouts.Features.Pages.FormLayout extends Appleseed.Layouts.BaseLayout
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
  }

  initialize: (root, options) ->
    super(root, options)

    window.layout = @

    @get('content.selector').bind 'change', @_contentSelectorChanged

  ### Private Methods ###

  _resourceType: 'page'

  _clearContent: =>
    @get('content.area').html('')

  _setContent: (htmlContent) =>
    @get('content.area').html(htmlContent)

  _deserializeContentData: (data) =>
    console.log 'Pages.FormLayout#deserializeData()'
    console.log data

    $(input = $("##{id}"))?.val(value) for id, value of data

  _serializeContentData: =>
    console.log 'Pages.FormLayout#serializeData()'

    data = {}
    for input in @get('content.inputs')
      $input = $(input)
      continue if !$input.attr('id') || $input.attr('id').match(/content_+type/)

      data[$input.attr('id')] = $input.val()

    @_serializedContentData = data

  _hideErrorNotice: =>
    @get('content.error').addClass('hidden')

  _hideLoadingNotice: =>
    @get('content.loading').addClass('hidden')

  _showErrorNotice: =>
    @get('content.error').removeClass('hidden')

  _showLoadingNotice: =>
    @get('content.loading').removeClass('hidden')

  ### Network Requests ###

  _requestContentFields: (contentType) =>
    console.log 'Pages.FormLayout#requestContentFields()'

    fieldsUrl = "/admin/contents/#{contentType}/fields?resource_type=#{@_resourceType}"
    console.log fieldsUrl

    request = $.get(fieldsUrl)
    request.done @_requestContentFieldsSuccess
    request.fail @_requestContentFieldsFailure

  ### Event Handlers ###

  _contentSelectorChanged: =>
    console.log 'Pages.FormLayout#contentSelectorChanged()'

    contentType = @get('content.selector').val()
    console.log contentType

    @_serializeContentData()
    @_clearContent()
    @_hideErrorNotice()
    @_showLoadingNotice()
    @_requestContentFields(contentType)

  _requestContentFieldsSuccess: (htmlContent, status, request) =>
    console.log 'Pages.FormLayout#requestContentFieldsSuccess()'
    console.log arguments

    @_hideLoadingNotice()
    @_setContent(htmlContent)
    @_deserializeContentData(@_serializedContentData) if @_serializedContentData?

  _requestContentFieldsFailure: (request, status, message) =>
    console.log 'Pages.FormLayout#requestContentFieldsFailure()'
    console.log arguments

    @_hideLoadingNotice()
    @_showErrorNotice()
