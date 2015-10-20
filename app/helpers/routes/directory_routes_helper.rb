# app/helpers/routes/directory_routes_helper.rb

module Routes
  module DirectoryRoutesHelper
    def create_directory_path directory
      index_directories_path directory
    end # method directory_path

    def dashboard_directory_path directory
      return '/dashboard' if directory.blank?

      Directory.join directory_path(directory), 'dashboard'
    end # method dashboard_directory_path

    def directory_path directory
      "/#{directory.try(:to_partial_path)}"
    end # method directory_path

    def edit_directory_path directory
      return '/edit' if directory.blank?

      Directory.join directory_path(directory), 'edit'
    end # method edit_directory_path

    def export_directory_path directory, pretty: false
      "#{directory.blank? ? '/export' : Directory.join(directory_path(directory), 'export')}#{pretty ? '?pretty=true' : ''}"
    end # method export_directory_path

    def index_directories_path directory
      return '/directories' if directory.blank?

      Directory.join directory_path(directory), 'directories'
    end # method index_directories_path

    def new_directory_path directory
      return '/directories/new' if directory.blank?

      Directory.join directory_path(directory), 'directories', 'new'
    end # method new_directory_path
  end # module
end # module
