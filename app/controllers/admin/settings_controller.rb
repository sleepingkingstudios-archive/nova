# app/controllers/admin/settings_controller.rb

require 'form_builders/bootstrap_horizontal_form_builder'

Dir[Rails.root.join *%w(lib serializers settings ** *.rb)].each { |file_name| require file_name }

class Admin::SettingsController < Admin::AdminController
  include DecoratorsHelper

  before_action :authenticate_user!
  before_action :load_settings, :only => %i(index)
  before_action :load_setting,  :only => %i(update)

  rescue_from Appleseed::AuthenticationError, :with => :handle_unauthorized_user

  def index

  end # action index

  def update
    form       = decorate(@setting, 'Form')
    serializer = decorator_class(@setting, :Serializer)

    if form.update(params)
      render :json => {
        :setting => serializer.serialize(@setting)
      } # end hash
    else
      render :status => :unprocessable_entity, :json => {
        :error   => 'Unable to update setting.',
        :setting => serializer.serialize(@setting)
      } # end hash
    end # if-else
  end # action update

  private

  def handle_unauthorized_user exception = nil
    if request.xhr?
      head :forbidden
    else
      flash[:warning] = "Unauthorized action"

      redirect_to root_path
    end # if-else
  end # method handle_unauthorized_user

  def load_settings
    @settings = Setting.all
  end # method load_settings

  def load_setting
    setting_id = params.fetch(:id)

    @setting = Setting.find(setting_id)
  end # method load_setting
end # class
