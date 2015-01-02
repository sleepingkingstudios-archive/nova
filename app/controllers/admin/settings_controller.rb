# app/controllers/admin/settings_controller.rb

require 'form_builders/bootstrap_horizontal_form_builder'

class Admin::SettingsController < Admin::AdminController
  before_action :load_settings

  def edit

  end # action edit

  private

  def load_settings
    @settings = Setting.all
  end # method load_settings
end # class
