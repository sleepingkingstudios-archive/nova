# app/controllers/admin/features/blogs_controller.rb

class Admin::Features::BlogsController < Admin::FeaturesController
  private

  def resource_class
    :blog
  end # method resource_class
end # class
