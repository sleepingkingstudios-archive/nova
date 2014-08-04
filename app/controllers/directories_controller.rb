# app/controllers/directories_controller.rb

class DirectoriesController < ApplicationController
  # GET /path/to/directory
  def show
    if params.fetch('directories', nil).blank?
      @directories = []
    else
      segments = params.fetch('directories', '').split('/')
      @directories = Directory.find_by_ancestry segments
    end # if-else
  end # action show

  rescue_from Directory::NotFoundError do |exception|
    @directories = exception.found
    render :show
  end # rescue_from
end # controller
