# spec/support/factories/features/blog_factories.rb

FactoryGirl.define do
  factory :blog, :class => 'Blog', :parent => :feature do
    sequence(:title) { |index| "Blog #{index}" }
  end # factory
end # define
