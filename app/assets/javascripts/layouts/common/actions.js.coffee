# app/assets/javascripts/layouts/common/actions.js.coffee

class Appleseed.Layouts.Common.Actions extends Appleseed.Layouts.BaseLayout
  @selectors: {
    delete_link: '.delete-link'
    modal:
      sel:     'body #confirm-delete-modal'
      action:  '.confirm-delete-button'
      body:    '.confirm-delete-body'
      title:   '.confirm-delete-title'
      warning: '.confirm-delete-warning'
  }

  initialize: (root, options) ->
    super(root, options)

    if @get('delete_link', false).length > 0
      @_mockDeleteLink()

  _configureModal: () =>
    data = @$el.data()

    if data['confirmDeleteAction']?
      @get('modal.action').text(data['confirmDeleteAction'])
    else
      @get('modal.body').text('<span class="fa fa-trash fa-lg"></span> Delete Page')

    if data['confirmDeleteBody']?
      @get('modal.body').html(data['confirmDeleteBody'])
    else
      @get('modal.body').text('Are you sure you want to delete this object?')

    if data['confirmDeleteTitle']?
      @get('modal.title').text(data['confirmDeleteTitle'])
    else
      @get('modal.title').text('Confirm Delete?')

    if data['confirmDeleteWarning']?
      @get('modal.warning').text(data['confirmDeleteWarning'])
    else
      @get('modal.warning').text('This cannot be undone!')

    @get('modal.action').bind 'click', => @get('delete_link').click()

  _mockDeleteLink: () =>
    $mock = @get('delete_link').clone()
    $mock.removeAttr('id').removeAttr('data-method')
    $mock.attr('href', '#')
    $mock.bind 'click', @_openModal

    @get('delete_link').after($mock).hide()

  _openModal: (event) =>
    event.preventDefault()

    @_configureModal()

    @get('modal').modal()
