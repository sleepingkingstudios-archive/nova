# app/assets/javascripts/layouts/settings/navigation_list_settings/form_layout.js.coffee

class Appleseed.Layouts.Settings.NavigationListSettings.FormLayout extends Appleseed.Layouts.Settings.FormLayout
  @selectors: {
    createItemButton: '.create-item-button'
    list: {
      sel: '.list-items'
      item: {
        sel: '> div.row'
        deleteItemButton:   '.delete-item-button'
        moveItemDownButton: '.move-item-down-button'
        moveItemUpButton:   '.move-item-up-button'
      }
      template: '.item-template div.row'
    }
  }

  initialize: (root, options) ->
    super(root, options)

    @get('createItemButton').on 'click', @createItem

    @get('list.item.deleteItemButton').on   'click', @deleteItem
    @get('list.item.moveItemDownButton').on 'click', @moveItemDown
    @get('list.item.moveItemUpButton').on   'click', @moveItemUp

    @get('list.template').find('input').attr('disabled', 'disabled')

    @_updateItemOrderingKeys()

  createItem: (event) =>
    event.preventDefault()

    $item = @get('list.template').clone()
    $item.find('input').removeAttr('disabled')
    @get('list.item').last().after($item)

    $item.find('.delete-item-button').on 'click',  @deleteItem
    $item.find('.move-item-up-button').on 'click', @moveItemUp

    @_updateItemOrderingKeys()

  deleteItem: (event) =>
    event.preventDefault()

    $item = $(event.target).closest('.navigation-list-item')
    $item.remove()

    @_updateItemOrderingKeys()

  moveItemUp: (event) =>
    event.preventDefault()

    $item = $(event.target).closest('.navigation-list-item')
    index = @get('list.item').index($item)

    return if 0 == index

    $prev = @get('list.item').eq(index - 1)
    $prev.before($item)

    @_updateItemOrderingKeys()

  moveItemDown: (event) =>
    event.preventDefault()

    $item = $(event.target).closest('.navigation-list-item')
    index = @get('list.item').index($item)
    count = @get('list.item').length

    return if count == index + 1

    $next = @get('list.item').eq(index + 1)
    $next.after($item)

    @_updateItemOrderingKeys()

  _formData: () =>
    $templateControls = @get('list.template').find('label, input[type="text"]')
    $templateControls.prop('disabled', true)

    data = super

    $templateControls.prop('disabled', false)

    data

  _updateItemOrderingKeys: () =>
    for item, index in @get('list.item')
      $item = $(item)

      for label in $item.find('label')
        $label = $(label)

        name = $label.attr('for')
        name = name.replace /value_-?\d+_/, "value_#{index}_"
        $label.attr('for', name)

      for control in $item.find('input[type="text"]')
        $control = $(control)

        name = $control.attr('name')
        name = name.replace /\[value\]\[-?\d+\]/, "[value][#{index}]"
        $control.attr('name', name)

        id = $control.attr('id')
        id = id.replace /value_-?\d+_/, "value_#{index}_"
        $control.attr('id', id)

    @get('list.item.moveItemDownButton').removeClass('disabled')
    @get('list.item.moveItemDownButton').last().addClass('disabled')

    @get('list.item.moveItemUpButton').removeClass('disabled')
    @get('list.item.moveItemUpButton').first().addClass('disabled')
