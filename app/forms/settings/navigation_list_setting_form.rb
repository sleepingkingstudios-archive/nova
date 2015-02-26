# app/forms/settings/navigation_list_setting_form.rb

class NavigationListSettingForm < SettingForm
  def update params
    # Store the list.
    list_was = resource.list

    if (value = params.fetch(resource_key, {}).fetch('value', nil)).blank?
      resource.list = nil
    else
      resource.list ||= resource.build_list
      resource.list.value = value
    end # if

    return true if super

    # Revert the list if validation failed.
    resource.list = list_was
    resource.list.save

    byebug

    false
  end # method update
end # class
