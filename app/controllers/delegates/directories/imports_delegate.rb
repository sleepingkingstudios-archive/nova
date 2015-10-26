# app/controllers/delegates/directories/imports_delegate.rb

require 'delegates/directories_delegate'

module Directories
  class ImportsDelegate < DirectoriesDelegate
    ### Partial Methods ###

    def new_template_path
      "admin/directories/imports/new"
    end # method edit_template_path
  end # class
end # module
