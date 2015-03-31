# app/forms/settings/setting_form.rb

class SettingForm < Form
  def resource_key
    'setting'
  end # method resource_key

  def resource_params params
    attributes = params.fetch(resource_key, {})
    attributes.permit(*permitted_params).merge('options' => attributes['options'])
  end # method resource_params
end # class
