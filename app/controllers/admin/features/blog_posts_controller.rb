# app/controllers/admin/features/blog_posts_controller.rb

class Admin::Features::BlogPostsController < Admin::FeaturesController
  private

  def resource_class
    :blog_post
  end # method resource_class
end # class
