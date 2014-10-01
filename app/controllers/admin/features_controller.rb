# app/controllers/admin/features_controller.rb

class Admin::FeaturesController < Admin::ResourcesController
  private

  def resource_class
    :feature
  end # method resource_class
end # class
