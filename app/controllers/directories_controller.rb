# app/controllers/directories_controller.rb

require 'form_builders/bootstrap_horizontal_form_builder'
require 'presenters/directory_presenter'

class DirectoriesController < ApplicationController
  include DirectoryLookup

  before_action :lookup_directories
  before_action :authenticate_user!, :except => %i(show)

  before_action :build_directory, :only => %i(new create)

  # GET /path/to/directory
  def show
  end # action show

  # DELETE /path/to/directory
  def destroy
    flash[:danger] = 'Directory successfully destroyed.'

    @current_directory.destroy

    redirect_to index_directory_path(@directories[-2])
  end # action destroy

  private

  def build_directory
    @directory = Directory.new create_params_for_directory
  end # method build_directory

  def create_params_for_directory
    params_for_directory.tap do |permitted|
      permitted[:parent] = @current_directory
    end # tap
  end # method create_params_for_directory

  def params_for_directory
    params.fetch(:directory, {}).permit(:title, :slug)
  end # method params_for_directory

  rescue_from Directory::NotFoundError do |exception|
    flash[:warning] = "Unable to locate directory — #{exception.missing.join('/')} (#{exception.missing.count} total)"

    @directories = exception.found

    redirect_to directory_path(@directories.last)
  end # rescue_from

  rescue_from Nova::AuthenticationError do |exception|
    flash[:warning] = "Unauthorized action"

    redirect_to directory_path(@directories.last)
  end # rescue_from
end # controller
