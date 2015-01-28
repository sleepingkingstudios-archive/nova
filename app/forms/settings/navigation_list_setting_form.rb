# app/forms/settings/navigation_list_setting_form.rb

class NavigationListSettingForm < SettingForm
  def update params
    if (value = params.fetch(resource_key, {}).fetch('value', nil)).blank?
      resource.list ? resource.list.destroy : nil
    else
      resource.list ||= resource.build_list
      resource.list.value = value
    end # if

    super
  end # method update
end # class
