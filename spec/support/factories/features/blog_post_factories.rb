# spec/support/factories/features/blog_post_factories.rb

FactoryGirl.define do
  factory :blog_post do
    sequence(:title) { |index| "Blog Post #{index}" }
  end # factory
end # define
