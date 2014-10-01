# app/controllers/admin/features/pages_controller.rb

class Admin::Features::PagesController < Admin::FeaturesController
  private

  def resource_class
    :page
  end # method resource_class
end # class
