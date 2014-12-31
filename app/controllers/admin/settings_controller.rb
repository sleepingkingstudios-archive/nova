# app/controllers/admin/settings_controller.rb

class Admin::SettingsController < Admin::AdminController
  before_action :load_settings

  def edit

  end # action edit

  private

  def load_settings
    @settings = Setting.all
  end # method load_settings
end # class
