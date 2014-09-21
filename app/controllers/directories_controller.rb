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

  # GET /path/to/directory/index
  def index
  end # action index

  # GET /path/to/directory/directories/new
  def new
  end # action new

  # POST /path/to/directory/directories
  def create
    if @directory.save
      flash[:success] = 'Directory successfully created.'

      redirect_to index_directory_path(@directory)
    else
      render :new
    end # if
  end # action create

  private

  def build_directory
    @directory = Directory.new params_for_directory
  end # method build_directory

  def params_for_directory
    params.fetch(:directory, {}).permit(:title, :slug).tap do |permitted|
      permitted[:parent] = @current_directory
    end # tap
  end # method params_for_directory

  rescue_from Directory::NotFoundError do |exception|
    flash[:warning] = "Unable to locate directory — #{exception.missing.join('/')} (#{exception.missing.count} total)"

    @directories = exception.found

    redirect_to directories_path(@directories)
  end # rescue_from

  rescue_from Nova::AuthenticationError do |exception|
    flash[:warning] = "Unauthorized action"

    redirect_to directories_path(@directories)
  end # rescue_from
end # controller
