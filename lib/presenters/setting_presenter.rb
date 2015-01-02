# lib/presenters/setting_presenter.rb

require 'presenters/presenter'

class SettingPresenter < Presenter
  alias_method :setting, :object

  def fields_partial_path
    setting.class == Setting ? 'admin/settings/fields' : "admin/settings/#{setting.class.to_s.pluralize.underscore}/fields"
  end # method fields_partial_path

  def label
    (setting.key || '').split('.').map(&:capitalize).join(' ')
  end # method label

  def name
    (setting.key || '').gsub('.', '_')
  end # method name
end # class
