# spec/controllers/delegates/features/imports_delegate_spec.rb

require 'delegates/resources_delegate'

module Features
  class ImportsDelegate < ResourcesDelegate
    def initialize object = nil
      super object || Feature
    end # method initialize

    ### Partial Methods ###

    def new_template_path
      "admin/features/imports/new"
    end # method edit_template_path
  end # class
end # module
